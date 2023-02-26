part of 'imei_info_bloc.dart';

abstract class ImeiInfoEvent {
  const ImeiInfoEvent();
}

class ImeiInfoRequest extends ImeiInfoEvent {
  /*Take user input*/
  // final String cityName;

  ImeiInfoRequest();
}
