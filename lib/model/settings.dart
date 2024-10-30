import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  Map<String, dynamic> appSettings = {};

  Settings() {
    restore();
  }

  Future<bool> persist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("settings", json.encode(appSettings));
  }

  Future<void> restore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String? prefStr = prefs.getString("settings");
      if (prefStr != null) {
        appSettings = await json.decode(prefStr);
      } else {
        setDefaults();
      }
      notifyListeners();
    } catch (e) {
      print(e);
      return;
    }
  }

  void setDefaults() {
    appSettings['theme'] = 'light';
  }

  Future<void> updateSetting(key, value) async {
    appSettings[key] = value;
    persist().then((value) => notifyListeners());
    //notifyListeners();
  }
}
