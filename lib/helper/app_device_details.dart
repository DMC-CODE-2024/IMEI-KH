import 'package:flutter/services.dart';

import '../main.dart';

abstract class IAppDeviceDetails {
  Future<String?> getDeviceDetails();
}

class AppDeviceDetails extends IAppDeviceDetails {
  @override
  Future<String?> getDeviceDetails() async {
    String? deviceDetails;
    try {
      deviceDetails = await platform.invokeMethod('getDeviceInfo');
    } on PlatformException catch (e) {
      e.stacktrace;
    }
    return deviceDetails;
  }
}
