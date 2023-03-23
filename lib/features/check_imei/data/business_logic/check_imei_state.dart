import '../../../launcher/data/models/device_details_res.dart';
import '../models/check_imei_res.dart';

abstract class CheckImeiState {}

class CheckImeiInitialState extends CheckImeiState {}

class CheckImeiLoadingState extends CheckImeiState {}
class CheckImeiPageRefresh extends CheckImeiState{}

class CheckImeiLoadedState extends CheckImeiState {
  CheckImeiRes checkImeiRes;

  CheckImeiLoadedState(this.checkImeiRes);
}

class CheckImeiErrorState extends CheckImeiState {
  String e;

  CheckImeiErrorState(this.e);
}

class LanguageLoadingState extends CheckImeiState {}

class LanguageErrorState extends CheckImeiState {
  String e;

  LanguageErrorState(this.e);
}

class LanguageLoadedState extends CheckImeiState {
  DeviceDetailsRes deviceDetailsRes;

  LanguageLoadedState(this.deviceDetailsRes);
}
