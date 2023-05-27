import 'package:eirs/main.dart';

const String selectedLang = "selectedLang";

Future setLocale(String languageCode) async {
  await sharedPref.setString(selectedLang, languageCode);
}

Future<String> getLocale() async {
  String languageCode = sharedPref.getString(selectedLang) ?? 'en';
  return languageCode;
}
