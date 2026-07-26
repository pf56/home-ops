# IoT DNS Audit

## Purpose

Provide auditable DNS visibility and encrypted-DNS transport controls for IoT devices.

## Requirements

### Requirement: The router SHALL record IoT DNS requests
The router SHALL emit a structured audit record for every TCP or UDP DNS request from `10.0.40.0/24` that reaches its resolver. Each record SHALL include the client source IPv4 address, fully qualified query name, DNS class, and query type. The record SHALL be emitted before the resolver cache and delivered through the existing router journald-to-Loki pipeline.

#### Scenario: IoT client receives a cached response
- **WHEN** an IoT client repeats a DNS query that the router serves from its cache
- **THEN** Loki contains an audit record for that request with the client's source IPv4 address and requested FQDN

#### Scenario: Non-IoT client resolves a name
- **WHEN** a DNS request originates outside `10.0.40.0/24`
- **THEN** the request follows the existing resolver path without producing an IoT DNS audit record

### Requirement: The router SHALL capture plaintext DNS sent to external resolvers
The router SHALL redirect TCP and UDP destination port 53 traffic arriving from `10.0.40.0/24` to its local resolver before it can be forwarded toward the WAN. The redirected request SHALL retain its client source IPv4 address for audit attribution.

#### Scenario: IoT client uses a hard-coded public resolver
- **WHEN** an IoT client sends a TCP or UDP DNS query on port 53 to an external resolver address
- **THEN** the router resolves the request locally and Loki contains an audit record with the IoT client's source IPv4 address and requested FQDN

### Requirement: The router SHALL deny common encrypted DNS transports from IoT devices
The router SHALL deny IoT WAN traffic to TCP port 853 and UDP ports 784, 853, and 8853. Denied traffic SHALL create rate-limited router log evidence that identifies the source IPv4 address and denied transport destination port.

#### Scenario: IoT client attempts DNS-over-TLS
- **WHEN** an IoT client sends traffic to TCP port 853 on a WAN destination
- **THEN** the router drops the traffic and emits rate-limited denial evidence to the router journal

#### Scenario: IoT client uses ordinary HTTPS
- **WHEN** an IoT client sends ordinary permitted HTTPS traffic on TCP port 443
- **THEN** the router does not classify that traffic as an encrypted-DNS-port denial

### Requirement: Grafana SHALL provide an IoT DNS audit view
Grafana SHALL provide a declaratively provisioned dashboard that reads the router's DNS audit records from Loki and displays the timestamp, source IPv4 address, FQDN, DNS class, and query type. The dashboard SHALL support filtering records by time range, source IPv4 address, and FQDN.

#### Scenario: Operator filters requests for an IoT source address
- **WHEN** an operator selects an IoT source IPv4 address and time range in the dashboard
- **THEN** the dashboard displays matching DNS audit records and their requested FQDNs

#### Scenario: Audit record ages beyond retention
- **WHEN** an IoT DNS audit record becomes older than 30 days
- **THEN** the record is subject to the existing default Loki retention policy
