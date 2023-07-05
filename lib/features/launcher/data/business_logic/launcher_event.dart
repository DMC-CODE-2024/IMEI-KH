abstract class LauncherEvent {
  const LauncherEvent();
}

class LauncherInitEvent extends LauncherEvent {
  int requestCode;
  String? languageType;
  String? deviceDetails;
  LauncherInitEvent({required this.requestCode,this.languageType,this.deviceDetails});
}