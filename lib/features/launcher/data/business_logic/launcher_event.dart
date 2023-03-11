abstract class LauncherEvent {
  const LauncherEvent();
}

class LauncherInitEvent extends LauncherEvent {
  String? languageType;
  LauncherInitEvent({this.languageType});
}