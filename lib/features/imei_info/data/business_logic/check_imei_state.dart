import 'package:eirs/features/imei_info/data/models/check_imei_res.dart';

abstract class CheckImeiState {}

class CheckImeiInitialState extends CheckImeiState {}

class CheckImeiLoadingState extends CheckImeiState {}

class CheckImeiLoadedState extends CheckImeiState {
  CheckImeiRes checkImeiRes;
  CheckImeiLoadedState(this.checkImeiRes);
}

class CheckImeiErrorState extends CheckImeiState {
  String e;

  CheckImeiErrorState(this.e);
}
