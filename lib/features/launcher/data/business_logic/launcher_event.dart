abstract class LauncherEvent {
  const LauncherEvent();
}

class LauncherInitEvent extends LauncherEvent {
  String? languageType;
  String? deviceDetails;
  LauncherInitEvent({this.languageType,this.deviceDetails});
}