## ADDED Requirements

### Requirement: Loki SHALL enforce a default retention period

Loki SHALL enable its compactor retention workflow and SHALL retain streams without a more-specific policy for 30 days. The retention configuration SHALL use the existing TSDB filesystem storage and SHALL keep compactor state on persistent storage.

#### Scenario: Unmatched stream reaches the default retention age

- **WHEN** a Loki stream does not match a stream-specific retention selector and its entries become older than 30 days
- **THEN** the compactor removes the entries from the Loki index and schedules their chunks for deletion

#### Scenario: Loki restarts during retention processing

- **WHEN** Loki restarts while retention markers or deletion requests exist
- **THEN** the compactor resumes processing from persistent state without requiring manual reconstruction of the retention state

### Requirement: Loki SHALL enforce stream-specific retention periods

Loki SHALL apply the following higher-priority retention periods using indexed label selectors:

- `service_name="restic"`: 7 days.
- `namespace="democratic-csi"`: 3 days.
- `job="systemd-journal",unit="loki.service"`: 3 days.

#### Scenario: Restic logs exceed seven days

- **WHEN** a stream has `service_name="restic"` and entries become older than 7 days
- **THEN** those entries become eligible for compactor retention deletion while newer entries remain queryable

#### Scenario: Democratic-csi logs exceed three days

- **WHEN** a stream has `namespace="democratic-csi"` and entries become older than 3 days
- **THEN** those entries become eligible for compactor retention deletion while newer entries remain queryable

#### Scenario: Loki self-logs exceed three days

- **WHEN** a stream has `job="systemd-journal"` and `unit="loki.service"` and entries become older than 3 days
- **THEN** those entries become eligible for compactor retention deletion while newer entries remain queryable

### Requirement: The monitoring host SHALL limit persistent journald retention

The monitoring host SHALL retain persistent systemd journal entries for no longer than 7 days and SHALL rotate journal files at least daily.

#### Scenario: Journal entries exceed seven days

- **WHEN** a persistent journal entry becomes older than 7 days
- **THEN** journald removes it during normal journal maintenance and does not retain it solely because the journal filesystem has free space

#### Scenario: Journal file reaches one day of age

- **WHEN** an active journal file reaches one day of age
- **THEN** journald rotates the file so age-based retention can remove older entries promptly

### Requirement: Historical cleanup SHALL be explicit and scoped

The change SHALL provide an operator procedure for removing existing data outside the new retention windows. The procedure SHALL use Loki's deletion API for Loki data and journald's supported vacuum operation for local journal data. It SHALL NOT require manually deleting Loki chunks or index files.

#### Scenario: Historical journald cleanup is performed

- **WHEN** the new journald configuration is deployed and the operator runs the approved seven-day vacuum
- **THEN** local journal entries older than seven days are removed without deleting newer entries

#### Scenario: Historical Loki cleanup is performed

- **WHEN** the operator submits reviewed deletion requests with explicit selectors and cutoff timestamps
- **THEN** matching old Loki entries are processed through the configured cancellation and compaction workflow, while entries inside each stream's retention window remain queryable

#### Scenario: Historical deletion request is found to be incorrect

- **WHEN** an operator identifies an incorrect Loki deletion request during its cancellation window
- **THEN** the request can be canceled before physical chunk deletion occurs

### Requirement: Retention changes SHALL preserve recent observability

The monitoring stack SHALL continue accepting and querying logs within the configured retention windows after the retention configuration is deployed.

#### Scenario: Recent Kubernetes and host logs are queried

- **WHEN** a user queries current logs from Kubernetes streams or the monitoring host's journal
- **THEN** Loki returns entries that are newer than the applicable retention period

#### Scenario: Loki remains healthy after compactor activation

- **WHEN** the compactor is enabled in the single-node Loki deployment
- **THEN** Loki remains ready, continues ingesting logs, and reports successful compaction or retention processing
