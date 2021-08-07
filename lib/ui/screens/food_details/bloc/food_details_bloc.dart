import 'package:calorie_counter/data/local/data_source/i_data_source.dart';
import 'package:calorie_counter/data/local/data_source/result.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'food_details_event.dart';

part 'food_details_state.dart';

class FoodDetailsBloc extends Bloc<FoodDetailsEvent, FoodDetailsState> {
  final DataSource _dataSource;

  final Food _food;
  int currentCount = 1;
  int currentCalories = 0;
  int currentCarbs = 0;
  int currentFat = 0;
  int currentProtein = 0;

  FoodDetailsBloc(this._food, this._dataSource) : super(InitialFoodDetailsState()) {
    currentCount = _food.numOfServings ?? 0;
    currentCalories = _food.calories ?? 0 * currentCount;
    currentCarbs = _food.carbs ?? 0 * currentCount;
    currentFat = _food.fat ?? 0 * currentCount;
    currentProtein = _food.protein ?? 0 * currentCount;
  }

  @override
  Stream<FoodDetailsState> mapEventToState(FoodDetailsEvent event) async* {
    if (event is SetupFoodDetailsEvent) {
      yield LoadingFoodDetailsState();
      yield LoadedFoodDetailsState(
          currentCalories, currentCarbs, currentFat, currentProtein, currentCount);
    } else if (event is IncrementEvent) {
      yield LoadingFoodDetailsState();
      currentCount += 1;
      currentCalories = _food.calories! * currentCount;
      currentCarbs = _food.carbs! * currentCount;
      currentFat = _food.fat! * currentCount;
      currentProtein = _food.protein! * currentCount;

      yield LoadedFoodDetailsState(
          currentCalories, currentCarbs, currentFat, currentProtein, currentCount);
    } else if (event is DecrementEvent) {
      if (currentCount >= 2) {
        yield LoadingFoodDetailsState();
        currentCount -= 1;
        currentCalories = _food.calories! * currentCount;
        currentCarbs = _food.carbs! * currentCount;
        currentFat = _food.fat! * currentCount;
        currentProtein = _food.protein! * currentCount;

        yield LoadedFoodDetailsState(
            currentCalories, currentCarbs, currentFat, currentProtein, currentCount);
      }
    } else if (event is AddFoodEvent) {
      //  Don't save if the old food is not changed
      if (currentCount == _food.numOfServings && _food.id != -1) {
        yield FoodSaveState(event.mealNutrients, '');
        return;
      }
      var result = await _dataSource.updateOrInsertFood(event.mealNutrients, _food, currentCount);
      if (result is Fail) {
        return;
      }

      var data = (result as Success<MealNutrients>).data;

      if (_food.id == -1) {
        yield FoodSaveState(data, 'Food added');
      } else {
        yield FoodSaveState(data, 'Food saved');
      }
    }
  }
}
