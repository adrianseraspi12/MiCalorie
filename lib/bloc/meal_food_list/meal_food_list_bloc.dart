import 'package:calorie_counter/data/local/data_source/i_data_source.dart';
import 'package:calorie_counter/data/local/data_source/result.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'meal_food_list_event.dart';

part 'meal_food_list_state.dart';

class MealFoodListBloc extends Bloc<MealFoodListEvent, MealFoodListState> {
  MealFoodListBloc(this._dataSource, this.mealNutrients) : super(InitialMealFoodListState());
  final DataSource _dataSource;

  MealNutrients mealNutrients;
  String date;
  List<Food> listOfFood = [];
  Food tempFood;

  @override
  Stream<MealFoodListState> mapEventToState(MealFoodListEvent event) async* {
    if (event is SetupFoodListEvent) {
      yield LoadingMealFoodListState();
      mealNutrients = event.mealNutrients;
      var listOfFoodResult = await _dataSource.getAllFood(mealNutrients.id);
      if (listOfFoodResult is Fail) {
        yield EmptyMealFoodListState();
      }
      listOfFood = (listOfFoodResult as Success<List<Food>>).data;
      if (listOfFood.isEmpty) {
        yield EmptyMealFoodListState();
        return;
      }
      yield LoadedMealFoodListState(listOfFood);
    } else if (event is RetainFoodListEvent) {
      yield LoadingMealFoodListState();
      tempFood = null;
      listOfFood.insert(event.index, event.food);
      yield LoadedMealFoodListState(listOfFood);
    } else if (event is TempRemoveFoodEvent) {
      yield LoadingMealFoodListState();
      tempFood = event.food;
      listOfFood.remove(event.food);
      if (listOfFood.isEmpty) {
        yield EmptyMealFoodListState();
        return;
      }
      yield LoadedMealFoodListState(listOfFood);
    } else if (event is RemoveFood) {
      if (tempFood != null) {
        var result = await _dataSource.removeFood(mealNutrients.id, tempFood);
        if (result is Fail) {
          return;
        }
        tempFood = null;
      }
      yield UpdateNutrientsState(event.isOnPop);
    }
  }
}
