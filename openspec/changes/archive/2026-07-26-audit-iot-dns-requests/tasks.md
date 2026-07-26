## 1. RouteDNS Audit Capture

- [x] 1.1 Add an optional source-CIDR query-log configuration to the nameserver role that routes matching clients through a JSON RouteDNS `query-log` group before `main-cached`, while preserving the existing non-matching resolver path.
- [x] 1.2 Configure the router nameserver role to audit `10.0.40.0/24` and confirm the generated RouteDNS settings retain the existing internal, Tailscale, public upstream, UDP, and TCP listener behavior.

## 2. IoT DNS Egress Enforcement

- [x] 2.1 Add an IPv4 nftables NAT prerouting redirect for TCP and UDP port 53 traffic arriving at the router from the IoT VLAN so hard-coded plaintext resolvers are handled by the router DNS listener.
- [x] 2.2 Add rate-limited, logging deny rules before the IoT WAN allow rules for TCP port 853 and UDP ports 784, 853, and 8853.

## 3. Grafana Audit View

- [x] 3.1 Add a local Grafana dashboard definition that parses the RouteDNS JSON journal records from Loki and displays timestamp, source IPv4 address, FQDN, DNS class, and query type.
- [x] 3.2 Provision the dashboard through the monitoring host configuration with time-range, source-IP, and FQDN filters, without creating FQDN or source-IP Loki stream labels.

## 4. Validation And Operator Verification

- [x] 4.1 Format the Nix changes and run the relevant Nix evaluation or `nix flake check`; validate the dashboard JSON and generated RouteDNS/nftables configuration.
- [x] 4.2 After an operator deploys the router and monitoring configurations, issue router-directed and hard-coded plaintext DNS queries from an IoT client or controlled IoT-subnet host; verify one structured Loki record per request, including a cache hit.
- [x] 4.3 After deployment, attempt TCP port 853 and UDP ports 784, 853, and 8853 from an IoT client or controlled IoT-subnet host; verify the traffic is denied and rate-limited router journal evidence is queryable in Loki.
- [x] 4.4 Verify the Grafana dashboard filters and renders the deployed IoT DNS audit records, then document the DNS-over-HTTPS and direct-IP audit limitations for the operator.
