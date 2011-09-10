function FindProxyForURL(url, host) {
  if (isPlainHostName(host))
    return "DIRECT";
  else
    return "PROXY proxy:8080; DIRECT";
}