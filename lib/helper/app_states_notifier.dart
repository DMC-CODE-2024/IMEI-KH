import 'package:flutter/material.dart';

import '../features/launcher/data/models/device_details_res.dart';

class AppStatesNotifier extends ChangeNotifier {
  LabelDetails? _value;

  AppStatesNotifier();

  void updateState(LabelDetails? value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  LabelDetails? get value => _value;
}
