import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/food_bloc.dart';
import 'package:calorie_counter/data/model/list_of_food.dart';
import 'package:calorie_counter/ui/search_food_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ListOfFood>(
      
      stream: BlocProvider.of<FoodBloc>(context).listOfFoodStream,
      
      builder: (context, snapshot) {
        final listOfFood = snapshot.data;

        if (listOfFood == null) {
          return SearchFoodScreen();
        }
        else {
          return Container();
        }

      },
      
      );
  }
}