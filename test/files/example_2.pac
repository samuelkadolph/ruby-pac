// Taken from http://findproxyforurl.com/pac_file_examples.html

function FindProxyForURL(url, host) {

// If IP address is internal or hostname resolves to internal IP, send direct.

	var resolved_ip = dnsResolve(host);

	if (isInNet(resolved_ip, "10.0.0.0", "255.0.0.0") ||
		isInNet(resolved_ip, "172.16.0.0",  "255.240.0.0") ||
		isInNet(resolved_ip, "192.168.0.0", "255.255.0.0") ||
		isInNet(resolved_ip, "127.0.0.0", "255.255.255.0"))
		return "DIRECT";

// Use a different proxy for each protocol.
      if (shExpMatch(url, "http:*"))  return "PROXY proxy1.domain.com:3128";
      if (shExpMatch(url, "https:*")) return "PROXY proxy2.domain.com:3128";
      if (shExpMatch(url, "ftp:*")) return "PROXY proxy3.domain.com:3128";

}