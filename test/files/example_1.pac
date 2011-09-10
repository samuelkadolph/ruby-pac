// Taken from http://findproxyforurl.com/pac_file_examples.html

function FindProxyForURL(url, host) {

// If URL has no dots in host name, send traffic direct.
	if (isPlainHostName(host))
		return "DIRECT";

// If specific URL needs to bypass proxy, send traffic direct.
	if (shExpMatch(url,"*domain.com*") ||
	    shExpMatch(url,"*vpn.domain.com*"))
		return "DIRECT";

// If IP address is internal or hostname resolves to internal IP, send direct.

	var resolved_ip = dnsResolve(host);

	if (isInNet(resolved_ip, "10.0.0.0", "255.0.0.0") ||
		isInNet(resolved_ip, "172.16.0.0",  "255.240.0.0") ||
		isInNet(resolved_ip, "192.168.0.0", "255.255.0.0") ||
		isInNet(resolved_ip, "127.0.0.0", "255.255.255.0"))
		return "DIRECT";

// If not on a internal/LAN IP address, send traffic direct.
	if (!isInNet(myIpAddress(), "10.10.1.0", "255.255.255.0"))
		return "DIRECT";

// All other traffic uses below proxies, in fail-over order.
	return "PROXY 1.2.3.4:8080; PROXY 4.5.6.7:8080; DIRECT";

}