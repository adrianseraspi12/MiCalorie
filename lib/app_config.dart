import 'dart:convert';
import 'package:flutter/services.dart';


class AppConfig {

  final String appId;
  final String appKey;

  AppConfig({this.appId, this.appKey});

  static Future<AppConfig> forCredentials() async {

    // load json file
    final contents = await rootBundle.loadString(
      'assets/config/key.json'
    );

    // decode json file
    final json = jsonDecode(contents);

    return AppConfig(appId: json['appId'], appKey: json['appKey']);
  }

}