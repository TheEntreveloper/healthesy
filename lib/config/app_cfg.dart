import 'package:flutter/material.dart';

class AppConfig {
  AppConfig._();

  static const String url = 'http://192.168.1.29:8087/';
  static GlobalKey<ScaffoldMessengerState> scaffoldmkey = GlobalKey<ScaffoldMessengerState>();
  static Map<String, dynamic> appSettings = {};
}
