abstract class CheckMultiImeiEvent {
  const CheckMultiImeiEvent();
}

class CheckMultiImeiInitEvent extends CheckMultiImeiEvent {
  Map<String, int>? imeiMap;
  String? languageType;
  int requestCode;
  CheckMultiImeiInitEvent({this.imeiMap, this.languageType,required this.requestCode});
}
