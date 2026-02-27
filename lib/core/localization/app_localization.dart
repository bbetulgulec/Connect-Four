import 'dart:convert';
import 'package:flutter/services.dart';

class AppLocalization {
  static Map<String, dynamic> _localizedStrings = {};

  static Future<void> load(String langCode) async {
    String jsonString = await rootBundle.loadString(
      'assets/lang/$langCode.json',
    );
    _localizedStrings = json.decode(jsonString);
  }

  static String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
