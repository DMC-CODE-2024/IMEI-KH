import 'dart:developer';

import 'package:flutter/services.dart';

import '../main.dart';


abstract class IAppScreenPrivacy {
  Future<void> enableScreenPrivacy();

  Future<void> disableScreenPrivacy();
}

class AppScreenPrivacyService extends IAppScreenPrivacy {


  @override
  Future<void> disableScreenPrivacy() async {
    try {
      await platform.invokeMethod('disableAppSecurity');
    } on PlatformException catch (e) {
      log('Failed to disable app security: "${e.message}"');
    }
  }

  @override
  Future<void> enableScreenPrivacy() async {
    try {
      await platform.invokeMethod('enableAppSecurity');
    } on PlatformException catch (e) {
      log('Failed to enable app security: "${e.message}"');
    }
  }
}
