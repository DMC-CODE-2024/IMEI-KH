import 'package:eirs/features/launcher/data/models/device_details_res.dart';

class LauncherState {}

class LauncherInitialState extends LauncherState {}

class  LauncherLoadingState extends LauncherState {}

class  LauncherLoadedState extends LauncherState {
  DeviceDetailsRes deviceDetailsRes;
  LauncherLoadedState(this.deviceDetailsRes);
}

class LauncherErrorState extends LauncherState {
  String e;
  LauncherErrorState(this.e);
}