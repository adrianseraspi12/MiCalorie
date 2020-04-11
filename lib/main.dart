import 'package:calorie_counter/bloc/food_bloc.dart';
import 'package:calorie_counter/ui/main_screen.dart';
import 'package:flutter/material.dart';

import 'bloc/bloc_provider.dart';

void main() {
  runApp(
    BlocProvider<FoodBloc>(
      bloc: FoodBloc(),
      child: MaterialApp(
        title: 'Calorie Counter',
        theme: ThemeData(
          primaryColor: Colors.red[400]
        ),
        home: MainScreen(),
      ),
    )
  );
}
