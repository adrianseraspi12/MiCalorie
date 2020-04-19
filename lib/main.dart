import 'package:calorie_counter/ui/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
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
