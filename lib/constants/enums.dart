enum ConnectionType { Wifi, Mobile }

enum ConnectionStatus {
  online,
  offline,
}

// IP type
enum IPType {
  ipv4("ipv4"),
  ipv6('ipv6');

  const IPType(this.value);

  final String value;
}

//Color codes for validating check imei status
enum StatusColor {
  red("#eb5757"),
  green("#219653"),
  yellow("#FFFF02"),
  darYellow("#8B8000");

  const StatusColor(this.value);

  final String value;
}
