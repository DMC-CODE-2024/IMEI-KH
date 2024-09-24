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

enum StatusColor {
  red("#eb5757"),
  green("#219653"),
  yellow("#FFFF02"),
  darYellow("#8B8000");

  const StatusColor(this.value);

  final String value;
}
