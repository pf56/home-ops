## Context

The router advertises `10.0.40.1` as the DNS server for the IoT subnet through Kea DHCP. Its RouteDNS UDP and TCP listeners currently send all client traffic directly to an in-memory cache, then to the existing internal, Tailscale, or public upstream routes. Router systemd journal entries are already collected by Alloy and written to the monitoring host's Loki instance; Grafana is provisioned declaratively from that host.

The IoT WAN policy permits approved device source IPs to make unrestricted outbound connections. This allows a device to use a hard-coded resolver or common encrypted DNS transport instead of the DHCP-provided resolver. The IoT VLAN does not receive IPv6 router advertisements or a delegated IPv6 prefix, so the audit boundary is IPv4.

## Goals / Non-Goals

**Goals:**

- Capture every IoT IPv4 plaintext DNS request that reaches, or is redirected to, the router resolver.
- Preserve the existing resolver, cache, and upstream routing behavior for all clients.
- Preserve source-IP attribution for the full `10.0.40.0/24` subnet without introducing FQDN or client-IP Loki labels.
- Transparently capture hard-coded TCP and UDP port 53 resolvers and deny common encrypted-DNS transports.
- Provide a declaratively provisioned Grafana view over the audit records retained by Loki's existing 30-day policy.

**Non-Goals:**

- Proving that a device connected to an address returned by DNS.
- Capturing FQDNs for direct-IP connections, DNS-over-HTTPS on ordinary HTTPS ports, or arbitrary encrypted application protocols.
- Assigning human-readable device names or correlating dynamic DHCP leases; the source IPv4 address is the machine identity.
- Replacing RouteDNS, Kea, Loki, Alloy, or Grafana.
- Changing the existing global or stream-specific Loki retention policies.

## Decisions

### Add a source-scoped RouteDNS audit branch before the cache

Add an optional `roles.nameserver` setting for source CIDRs that require query logging. When configured on the router for `10.0.40.0/24`, the RouteDNS listeners first enter a source router. The IoT route passes through a RouteDNS `query-log` group configured for JSON output to stdout, then returns to the existing `main-cached` group. All other sources go directly to that cache.

This placement records cache hits, retries, and cache misses while retaining the current cache and split-horizon routing logic. JSON stdout is captured by the existing `routedns.service` journal stream and therefore reaches Loki without a separate collector or file lifecycle.

Alternatives considered:

- Put the logger after the cache: rejected because it records only cache misses.
- Log all clients: rejected because the requested audit scope is the IoT subnet and logging unrelated DNS traffic increases sensitive-data collection.
- Add FQDN or source IP as Loki labels: rejected because FQDN is unbounded and extracted JSON fields are sufficient for dashboard filtering.

### Transparently redirect IoT plaintext DNS and deny common encrypted DNS

Add an IPv4 nftables NAT prerouting chain that redirects TCP and UDP destination port 53 traffic arriving at the router from the IoT VLAN to the router's local DNS listener. The redirect applies whether the device selected the router or a hard-coded external resolver and preserves the original source IP observed by RouteDNS.

Add explicit, rate-limited logging deny rules in `IOT-WAN` before the existing per-device WAN allows for TCP port 853 and UDP ports 784, 853, and 8853. These cover standard DNS-over-TLS and common DNS-over-QUIC ports. The denial entries provide bypass-attempt evidence through the current router journald pipeline.

Alternatives considered:

- Drop external port 53: rejected because hard-coded devices would lose DNS instead of being audited.
- Permit encrypted DNS and merely log it: rejected because the requested FQDN cannot be recovered from encrypted traffic.
- Block all HTTPS to eliminate DNS-over-HTTPS: rejected because it would break ordinary IoT cloud access and still would not provide a general outbound-connection audit.

### Query Loki logs directly from a provisioned Grafana dashboard

Add a local Grafana dashboard definition to the monitoring host's existing dashboard provisioning list. Its Loki queries select the router's RouteDNS journal stream and parse JSON at query time, displaying timestamp, source IPv4 address, FQDN, DNS class, and query type. The dashboard provides time-range, source-IP, and FQDN filtering.

The dashboard treats an IoT source IPv4 address as the requesting machine. It does not join Kea lease data or map addresses to labels because that identity inventory does not yet exist as machine-readable configuration.

Alternatives considered:

- Emit Prometheus metrics for each FQDN: rejected because the domain label has unbounded cardinality and loses individual audit events.
- Extract audit fields as Loki labels: rejected because query-time parsing avoids a schema change and cardinality growth.

### Retain logs under the existing 30-day default policy

The new audit lines use the existing router journald Loki stream and therefore inherit the configured 30-day global retention period. No new retention selector is added.

## Risks / Trade-offs

- [DNS-over-HTTPS over permitted TCP 443 can bypass the audit.] -> Document this as a DNS-audit limit; use a separate outbound-flow observability change if stronger egress evidence is needed.
- [IoT devices may retry blocked encrypted DNS and produce log volume.] -> Rate-limit denial logging while still dropping each prohibited connection.
- [Redirecting a hard-coded resolver changes the resolver used by that device.] -> Route traffic through the existing router resolver, which is already DHCP-advertised for the subnet, and validate internal and public lookup behavior after deployment.
- [A JSON parser or dashboard query can drift from RouteDNS output.] -> Validate with a known IoT query and inspect the exact journal and Loki event before considering deployment complete.
- [DNS records reveal sensitive device behavior.] -> Restrict collection to the IoT subnet and rely on the existing Grafana/Loki access controls and 30-day retention window.

## Migration Plan

1. Add and format the declarative RouteDNS, nftables, and Grafana dashboard configuration.
2. Evaluate the router and monitoring configurations and validate the dashboard JSON before deployment.
3. Deploy the router configuration, then test a router-directed and hard-coded plaintext DNS lookup from an IoT client or controlled test host.
4. Deploy the monitoring configuration and verify the parsed audit records in Grafana.
5. Confirm that common encrypted-DNS-port attempts are denied and rate-limited journald evidence reaches Loki.

Rollback consists of reverting the router redirect, encrypted-DNS denial rules, RouteDNS audit branch, and dashboard provisioning. Existing audit entries remain in Loki until their normal 30-day retention expiry.

## Open Questions

- None for the initial source-IP-based audit design.
