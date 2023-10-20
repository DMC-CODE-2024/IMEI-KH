import 'package:eirs/main.dart';
import '../constants/strings.dart';

Future setLocale(String languageCode) async {
  await sharedPref.setString(StringConstants.selectedLang, languageCode);
}

Future<String> getLocale() async {
  String languageCode = sharedPref.getString(StringConstants.selectedLang) ??
      StringConstants.khmerCode;
  return languageCode;
}

Future setDeviceId(String uniqueId) async {
  await sharedPref.setString(StringConstants.deviceId, uniqueId);
}

Future<String?> getDeviceId() async {
  return sharedPref.getString(StringConstants.deviceId);
}
