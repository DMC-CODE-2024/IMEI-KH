import 'package:eirs/main.dart';

const String selectedLang = "selectedLang";
const String deviceId = "device_id";

Future setLocale(String languageCode) async {
  await sharedPref.setString(selectedLang, languageCode);
}

Future<String> getLocale() async {
  String languageCode = sharedPref.getString(selectedLang) ?? 'en';
  return languageCode;
}


Future setDeviceId(String uniqueId) async {
  await sharedPref.setString(deviceId,uniqueId);
}

Future<String?> getDeviceId() async {
  return sharedPref.getString(deviceId);
}
