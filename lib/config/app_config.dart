import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String appId;
  final String appKey;

  AppConfig({required this.appId, required this.appKey});

  static Future<AppConfig> forCredentials() async {
    // load the json file
    final contents = await rootBundle.loadString('assets/config/key.json');

    //  decode json
    final json = jsonDecode(contents);

    //  convert json to AppConfig object
    return AppConfig(appId: json["appId"], appKey: json["appKey"]);
  }
}
