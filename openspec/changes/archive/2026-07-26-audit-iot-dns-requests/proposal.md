## Why

IoT devices can make opaque external DNS requests, while the router currently has no complete record of the requested FQDN or the source device address. Capturing those requests at the router makes the IoT network auditable without replacing the existing resolver or log pipeline.

## What Changes

- Record every DNS request received from the IoT IPv4 subnet (`10.0.40.0/24`) with its source IP, FQDN, DNS class, and query type.
- Transparently redirect IoT plaintext DNS sent to any TCP or UDP port 53 destination through the router resolver so hard-coded public resolvers are audited without breaking devices.
- Deny and rate-limit-log common encrypted-DNS ports from the IoT subnet to surface attempted bypasses.
- Provision a Grafana dashboard for searching and reviewing the IoT DNS audit log through Loki.
- Retain IoT DNS audit entries under the existing 30-day Loki default retention period.

## Capabilities

### New Capabilities
- `iot-dns-audit`: Capture, retain, and present IoT DNS request records and enforce the plaintext DNS path through the router.

### Modified Capabilities

- None.

## Impact

- Router RouteDNS and nftables configuration under `nix/modules/services/nameserver/` and `nix/hosts/router/`.
- Router journald-to-Loki ingestion through the existing Alloy monitoring client.
- Grafana dashboard provisioning on the monitoring host.
- IoT devices that use a hard-coded plaintext resolver are redirected to the router; common encrypted-DNS transports are denied.
