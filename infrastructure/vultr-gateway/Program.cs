using System.Collections.Generic;
using ediri.Vultr;
using Pulumi;

return await Deployment.RunAsync(() =>
{
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
		}
	}, new CustomResourceOptions { Protect = true });

	// Export outputs here
	return new Dictionary<string, object?>
	{
		["ipv4"] = routerVm.MainIp,
		["ipv6"] = routerVm.V6MainIp
	};
});