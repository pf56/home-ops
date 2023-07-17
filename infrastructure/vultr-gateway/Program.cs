using System.Collections.Generic;
using ediri.Vultr;
using Pulumi;

return await Deployment.RunAsync(() =>
{
	FirewallGroup firewall = new("firewall", new FirewallGroupArgs
	{
		Description = "firewall for the router"
	});

	// FirewallRule firewallSshV4 = new("firewall-ssh-4", new FirewallRuleArgs
	// {
	// 	FirewallGroupId = firewall.Id,
	// 	Protocol = "tcp",
	// 	IpType = "v4",
	// 	Subnet = "0.0.0.0",
	// 	SubnetSize = 0,
	// 	Port = "2704",
	// 	Notes = "Allow SSH"
	// });
	//
	// FirewallRule firewallSshV6 = new("firewall-ssh-6", new FirewallRuleArgs
	// {
	// 	FirewallGroupId = firewall.Id,
	// 	Protocol = "tcp",
	// 	IpType = "v6",
	// 	Subnet = "::",
	// 	SubnetSize = 0,
	// 	Port = "2704",
	// 	Notes = "Allow SSH"
	// });

	FirewallRule firewallWireguardV4 = new("firewall-wireguard-4", new FirewallRuleArgs
	{
		FirewallGroupId = firewall.Id,
		Protocol = "udp",
		IpType = "v4",
		Subnet = "0.0.0.0",
		SubnetSize = 0,
		Port = "29626",
		Notes = "Allow Wireguard"
	});

	FirewallRule firewallWireguardV6 = new("firewall-wireguard-6", new FirewallRuleArgs
	{
		FirewallGroupId = firewall.Id,
		Protocol = "udp",
		IpType = "v6",
		Subnet = "::",
		SubnetSize = 0,
		Port = "29626",
		Notes = "Allow Wireguard"
	});

	FirewallRule firewallBgpV6 = new("firewall-bgp-6", new FirewallRuleArgs
	{
		FirewallGroupId = firewall.Id,
		Protocol = "tcp",
		IpType = "v6",
		Subnet = "2001:19f0:ffff::1",
		SubnetSize = 128,
		Port = "179",
		Notes = "Allow BGP"
	});

	Instance routerVm = new("router", new InstanceArgs
	{
		Hostname = "vm-router-prod-fra-01",
		Label = "gateway",
		Tags = { "vyos", "router" },
		Plan = "vc2-1c-1gb",
		Region = "fra",
		EnableIpv6 = true,
		IsoId = "110ad3e2-ec20-4d4d-a2a8-2a593e367c01",
		VpcIds =
		{
			"10509d8c-b9b7-40b3-95f4-b7da469bac41" // main
		},
		FirewallGroupId = firewall.Id
	}, new CustomResourceOptions { Protect = true });

	// Export outputs here
	return new Dictionary<string, object?>
	{
		["ipv4"] = routerVm.MainIp,
		["ipv6"] = routerVm.V6MainIp
	};
});