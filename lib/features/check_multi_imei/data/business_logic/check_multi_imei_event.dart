abstract class CheckMultiImeiEvent {
  const CheckMultiImeiEvent();
}

class CheckMultiImeiInitEvent extends CheckMultiImeiEvent {
  Map<String, int> imeiMap;
  String? languageType;

  CheckMultiImeiInitEvent({required this.imeiMap, this.languageType});
}
