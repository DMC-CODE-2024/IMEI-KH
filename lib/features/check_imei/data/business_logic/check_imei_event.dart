part of 'check_imei_bloc.dart';

abstract class CheckImeiEvent {
  const CheckImeiEvent();
}

class CheckImeiInitEvent extends CheckImeiEvent {
  String? inputImei;
  CheckImeiInitEvent({ this.inputImei});
}


class LanguageInitEvent extends CheckImeiEvent{
  String languageType;
  LanguageInitEvent({required this.languageType});
}
