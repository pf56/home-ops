## Why

The monitoring host is accumulating log data without an effective age-based retention policy. Loki retains logs indefinitely, and the monitoring host's persistent journald configuration has no explicit time limit, allowing routine system, Kubernetes, and monitoring-service logs to consume disk space continuously.

## What Changes

- Enable Loki compactor retention for the existing single-node TSDB/filesystem deployment.
- Set a 30-day default Loki retention period.
- Apply shorter stream-specific retention periods: 7 days for restic backup logs, and 3 days for democratic-csi and Loki self-logs.
- Configure the monitoring host's persistent journald with a 7-day retention limit and daily journal-file rotation.
- Define a safe procedure for removing historical Loki and journald data beyond the new retention windows.
- Preserve existing log collection and query functionality for data within the configured retention windows.

## Capabilities

### New Capabilities

- `monitoring-log-retention`: Retention and historical cleanup policy for Loki streams and the monitoring host's systemd journal.

### Modified Capabilities

<!-- No existing capability requirements are changing. -->

## Impact

- NixOS monitoring-server Loki configuration in `nix/modules/services/monitoring/monitoring.nix`.
- Monitoring-host journald configuration in `nix/hosts/monitoring/monitoring.nix`.
- Existing Loki filesystem storage under `/var/lib/loki` and persistent systemd journal storage.
- Historical logs older than the new retention windows will become unavailable after cleanup.
