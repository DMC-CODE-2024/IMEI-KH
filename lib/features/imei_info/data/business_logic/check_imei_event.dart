part of 'check_imei_bloc.dart';

abstract class CheckImeiEvent {
  const CheckImeiEvent();
}

class CheckImeiInitEvent extends CheckImeiEvent {
  String inputImei;
  CheckImeiInitEvent({required this.inputImei});
}
