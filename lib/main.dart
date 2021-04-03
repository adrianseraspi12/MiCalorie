import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:calorie_counter/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

void main() {

 FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(
    MaterialApp(
      title: 'Calorie Counter',
      theme: ThemeData(
        primaryColor: Colors.red[400]
      ),
      home: MainScreen(),
    )
  );
}
