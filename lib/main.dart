import 'package:calorie_counter/app.dart';
import 'package:calorie_counter/data/api/service.dart';
import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // if (kDebugMode) {
  //   // Force disable Crashlytics collection while doing every day development.
  //   // Temporarily toggle this to true if you want to test crash reporting in your app.
  //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  // } else {
  //   // Handle Crashlytics enabled status when not in Debug,
  //   // e.g. allow your users to opt-in to crash reporting.
  // }

  // Initialize database
  var appDatabase = await AppDatabase.getInstance();
  var config = await Service.setUpClientConfig();

  runApp(App(
      mainDataSource: Injection.provideMainDataSource(appDatabase),
      edamanClient: Injection.provideClient(config)
    )
  );
}
