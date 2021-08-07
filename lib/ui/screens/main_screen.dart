import 'package:calorie_counter/ui/screens/daily_summary/ui/daily_summary_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: DailySummaryScreen());
  }
}