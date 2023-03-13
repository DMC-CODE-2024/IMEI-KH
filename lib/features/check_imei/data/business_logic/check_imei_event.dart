part of 'check_imei_bloc.dart';

abstract class CheckImeiEvent {
  const CheckImeiEvent();
}

class CheckImeiInitEvent extends CheckImeiEvent {
  String? inputImei;
  String? languageType;
  int requestCode;

  CheckImeiInitEvent(
      {this.inputImei, this.languageType, required this.requestCode});
}
