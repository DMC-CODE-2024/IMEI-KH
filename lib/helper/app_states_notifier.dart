import 'package:flutter/material.dart';

import '../features/launcher/data/models/device_details_res.dart';

class AppStatesNotifier extends ChangeNotifier {
  LabelDetails? _value;
  bool _isEnglish = true;

  AppStatesNotifier();

  void updateState(LabelDetails? value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  LabelDetails? get value => _value;

  void updateLanguageState(bool status) {
    if (_isEnglish == status) {
      return;
    }
    _isEnglish = status;
    notifyListeners();
  }

  bool get languageStatus => _isEnglish;
}
