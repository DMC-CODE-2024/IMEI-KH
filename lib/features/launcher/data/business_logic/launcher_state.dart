import 'package:eirs/features/launcher/data/models/device_details_res.dart';

class LauncherState {}

class LauncherInitialState extends LauncherState {}
class LauncherPreInitState extends LauncherState {}

class  LauncherLoadingState extends LauncherState {}

class  LauncherLoadedState extends LauncherState {
  DeviceDetailsRes deviceDetailsRes;
  LauncherLoadedState(this.deviceDetailsRes);
}

class LauncherErrorState extends LauncherState {
  String e;
  LauncherErrorState(this.e);
}


class  LauncherPreInitLoadingState extends LauncherState {}
class  LauncherPreInitLoadedState extends LauncherState {
  LauncherPreInitLoadedState();
}
class LauncherPreInitErrorState extends LauncherState {
  String e;
  LauncherPreInitErrorState(this.e);
}