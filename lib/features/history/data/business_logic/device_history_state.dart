abstract class DeviceHistoryState {}

class DeviceHistoryInitialState extends DeviceHistoryState {}

class DeviceHistoryLoadingState extends DeviceHistoryState {}

class DeviceHistoryLoadedState extends DeviceHistoryState {
  List<Map<String, dynamic>> deviceHistory;

  DeviceHistoryLoadedState(this.deviceHistory);
}

class DeviceHistoryErrorState extends DeviceHistoryState {
  String e;

  DeviceHistoryErrorState(this.e);
}

class NoDataDeviceHistoryState extends DeviceHistoryState {
  String message;

  NoDataDeviceHistoryState(this.message);
}
