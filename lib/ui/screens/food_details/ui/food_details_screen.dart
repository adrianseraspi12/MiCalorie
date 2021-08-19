import 'package:calorie_counter/data/local/data_source/main_data_source.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/screens/food_details/bloc/food_details_bloc.dart';
import 'package:calorie_counter/ui/screens/food_details/ui/food_details_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FoodDetailsScreen extends StatelessWidget {
  final Food food;
  final MealNutrients _mealNutrients;

  FoodDetailsScreen(this.food, this._mealNutrients);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodDetailsBloc(
        food,
        RepositoryProvider.of<MainDataSource>(context),
      ),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(193, 214, 233, 1),
        body: SafeArea(child: FoodDetailsContent(food: food, mealNutrients: _mealNutrients)),
      ),
    );
  }
}
