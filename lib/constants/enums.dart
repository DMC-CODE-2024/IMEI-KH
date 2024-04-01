enum ConnectionType { Wifi, Mobile }

enum ConnectionStatus {
  online,
  offline,
}

enum IPType {
  ipv4("ipv4"),
  ipv6('ipv6');

  const IPType(this.value);

  final String value;
}
