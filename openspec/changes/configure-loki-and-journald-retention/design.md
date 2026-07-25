## Context

The monitoring host runs Loki as a single NixOS service using TSDB v13 with a 24-hour index period and filesystem-backed chunks under `/var/lib/loki`. The effective Loki configuration has compaction enabled by default but retention disabled, so stored logs are not aged out. The monitoring host also uses persistent systemd journal storage without an explicit age limit.

Loki receives Kubernetes logs through the Kubernetes monitoring Alloy deployment, Talos logs through Vector, and local systemd journal logs through Alloy. Existing labels provide stable selectors for the requested policies, including `service_name`, `namespace`, `job`, and `unit`.

## Goals / Non-Goals

**Goals:**

- Bound Loki storage with a 30-day default retention period.
- Apply 7-day retention to restic backup streams.
- Apply 3-day retention to democratic-csi streams and Loki's own systemd service streams.
- Enable the Loki compactor and filesystem-backed deletion workflow.
- Bound the monitoring host's persistent journald data to 7 days.
- Rotate journald files daily so the age limit is applied promptly.
- Provide a cautious, repeatable procedure for cleaning historical data.

**Non-Goals:**

- Changing log collection, label schemas, application log levels, or Alloy filtering.
- Changing retention on other hosts.
- Adding object storage or migrating Loki away from local filesystem storage.
- Automatically executing destructive historical deletion during every system activation.

## Decisions

### Configure retention in the existing Loki module

Add the compactor and `limits_config` entries to `nix/modules/services/monitoring/monitoring.nix`, next to the existing Loki storage and schema configuration. This keeps retention attached to the service that owns the Loki deployment rather than introducing a second configuration mechanism.

The compactor will use the existing local filesystem storage, a persistent working directory at `/var/lib/loki/compactor`, a 10-minute compaction interval, a 2-hour deletion delay, and a filesystem delete-request store. The deletion delay preserves a recovery window and allows indexes to refresh before chunks are removed.

### Use a global default with higher-priority stream overrides

Set `limits_config.retention_period` to `30d`. Add `retention_stream` selectors with explicit priorities:

- `{service_name="restic"}` for `7d`.
- `{namespace="democratic-csi"}` for `3d`.
- `{job="systemd-journal",unit="loki.service"}` for `3d`.

All selectors use indexed labels only. No content filters or parser expressions will be used in retention selectors. The stream-specific rules override the global period because they have higher priority.

### Configure journald only on the monitoring host

Add host-specific journald settings to `nix/hosts/monitoring/monitoring.nix`:

- `MaxRetentionSec=7day` limits the age of persistent journal entries.
- `MaxFileSec=1day` rotates journal files daily so old entries do not remain in an active file for an unnecessarily long period.

The existing persistent storage behavior is retained. A one-time `journalctl --vacuum-time=7d` operation is used after deployment to remove already-expired local entries.

### Handle historical Loki cleanup as a guarded operational step

Retention configuration is declarative, but historical deletion is destructive and must not run automatically on every deployment. After the new configuration is deployed and verified, issue Loki deletion requests with explicit label selectors and cutoff timestamps for:

- Restic data older than 7 days.
- Democratic-csi data older than 3 days.
- Loki self-logs older than 3 days.
- Remaining data older than 30 days, using an enumerated selector set rather than an unreviewed catch-all request.

The deletion workflow will use Loki's TSDB deletion API and `filter-and-delete` mode, retain the cancellation window, and wait for compactor processing before checking disk usage. No files under `/var/lib/loki` will be removed manually.

### Validate both configuration and runtime behavior

Validation will include Nix evaluation and `nix flake check`, confirmation of the effective Loki configuration and health endpoint, inspection of compactor metrics or logs, journald usage checks, and queries proving that data inside each retention window remains available.

## Risks / Trade-offs

- **Historical deletion is irreversible.** -> Review selectors and cutoff timestamps, preserve the deletion cancellation window, and take a filesystem backup or snapshot when available before cleanup.
- **Retention reduces troubleshooting history.** -> Keep the global 30-day period and the longer 7-day restic period; document the shorter exceptions.
- **Filesystem deletion may temporarily increase compactor disk usage.** -> Keep the compactor working directory persistent and monitor free space during cleanup.
- **A selector may not match every intended stream.** -> Inventory current labels before submitting deletion requests and verify the resulting queries.
- **Journald and Loki have independent retention.** -> Configure both layers and verify each layer separately.
- **Loki retention configuration changes may not remove already-ingested data.** -> Use the separate, explicitly scoped deletion procedure for historical chunks.

## Migration Plan

1. Add and validate the declarative Loki and journald configuration.
2. Deploy the monitoring host and confirm Loki readiness, effective retention settings, and journald configuration.
3. Confirm new log ingestion and queries for recent data.
4. Run the one-time journald vacuum for entries older than seven days.
5. Review and submit scoped Loki historical deletion requests.
6. Wait through the deletion cancellation and compaction delays, then verify disk usage and recent queries.

Rollback consists of reverting the declarative configuration and restarting the affected services. Reverting cannot restore data already removed by journald vacuum or Loki deletion requests.

## Open Questions

- The exact selector inventory for the final 30-day historical cleanup must be captured immediately before deletion so newly discovered stream types are not accidentally omitted.
- A filesystem snapshot or backup of `/var/lib/loki` is desirable before historical deletion, but the repository does not currently define one for this host.
