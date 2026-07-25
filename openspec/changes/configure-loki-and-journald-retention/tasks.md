## 1. Configure Loki retention

- [x] 1.1 Add the persistent Loki compactor working directory, retention enablement, filesystem delete-request store, compaction interval, and deletion delay to `nix/modules/services/monitoring/monitoring.nix`.
- [x] 1.2 Add a 30-day global retention period and higher-priority 7-day restic, 3-day democratic-csi, and 3-day Loki self-log stream selectors to the Loki limits configuration.
- [x] 1.3 Confirm the retention selectors use only labels that are currently indexed by the live Loki deployment.

## 2. Configure monitoring-host journald

- [x] 2.1 Add host-specific journald settings to `nix/hosts/monitoring/monitoring.nix` with `MaxRetentionSec=7day` and `MaxFileSec=1day`.
- [x] 2.2 Confirm the journald configuration remains persistent and is scoped only to the monitoring host.

## 3. Validate and deploy the configuration

- [x] 3.1 Format the changed Nix files with the repository formatter.
- [x] 3.2 Run the relevant Nix evaluation and `nix flake check` validation.
- [x] 3.3 Deploy the monitoring host configuration and confirm Loki readiness, effective retention settings, compactor state, and journald configuration.
- [x] 3.4 Verify that recent Kubernetes, host, restic, democratic-csi, and Loki log queries continue to return data.

## 4. Clean up historical data safely

- [x] 4.1 Inventory current Loki label selectors and, where available, take a filesystem backup or snapshot of `/var/lib/loki` before destructive cleanup.
- [ ] 4.2 Run the one-time journald vacuum for entries older than seven days and verify the resulting journal usage.
- [x] 4.3 Submit reviewed Loki deletion requests for restic data older than seven days, democratic-csi and Loki self-logs older than three days, and remaining enumerated streams older than 30 days.
- [ ] 4.4 Wait through the Loki deletion cancellation and compaction delays, then verify that old data is gone, recent data remains queryable, and `/var/lib/loki` usage decreases.
