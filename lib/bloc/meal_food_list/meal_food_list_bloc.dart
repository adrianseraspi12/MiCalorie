import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'meal_food_list_event.dart';

part 'meal_food_list_state.dart';

class MealFoodListBloc extends Bloc<MealFoodListEvent, MealFoodListState> {
  MealFoodListBloc(
      this._dayRepository, this._mealNutrientsRepository, this._foodRepository)
      : super(InitialMealFoodListState());

  final TotalNutrientsPerDayRepository _dayRepository;
  final MealNutrientsRepository _mealNutrientsRepository;
  final FoodRepository _foodRepository;

  int mealId;
  String date;
  List<Food> listOfFood;
  Food tempFood;

  @override
  Stream<MealFoodListState> mapEventToState(MealFoodListEvent event) async* {
    if (event is SetupFoodListEvent) {
      yield LoadingMealFoodListState();
      mealId = event.mealId;
      listOfFood = await _foodRepository.findAllDataWith(mealId);
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
        await _updateNutrients(tempFood);
        _foodRepository.remove(tempFood);
        tempFood = null;
      }
      yield UpdateNutrientsState(event.isOnPop);
    }
  }

  Future _updateNutrients(Food food) async {
    final numberOfServings = food.numOfServings;

    final calories = food.calories * numberOfServings;
    final carbs = food.carbs * numberOfServings;
    final fat = food.fat * numberOfServings;
    final protein = food.protein * numberOfServings;

    final currentMeal = await _mealNutrientsRepository.getMeal(mealId);
    int totalNutrientsPerDayId = await _updateMealNutrient(food);
    await _updateTotalNutrients(
        totalNutrientsPerDayId, currentMeal, calories, carbs, fat, protein);
    return _updateMeal(currentMeal, calories, carbs, fat, protein);
  }

  Future<int> _updateMealNutrient(Food food) async {
    final currentMeal = await _mealNutrientsRepository.getMeal(mealId);
    return currentMeal.totalNutrientsPerDayId;
  }

  Future<int> _updateTotalNutrients(int totalNutrientsId, MealNutrients meal,
      int calories, int carbs, int fat, int protein) async {
    final totalNutrientsPerDay =
        await _dayRepository.getTotalNutrientsById(totalNutrientsId);

    final updatedTotalNutrients = TotalNutrientsPerDay(
        totalNutrientsPerDay.id,
        totalNutrientsPerDay.date,
        totalNutrientsPerDay.calories - calories,
        totalNutrientsPerDay.carbs - carbs,
        totalNutrientsPerDay.fat - fat,
        totalNutrientsPerDay.protein - protein);

    return _dayRepository.upsert(updatedTotalNutrients);
  }

  Future _updateMeal(
      MealNutrients meal, int calories, int carbs, int fat, int protein) async {
    final mealNutrients = MealNutrients(
        meal.id,
        meal.calories - calories,
        meal.carbs - carbs,
        meal.fat - fat,
        meal.protein - protein,
        meal.type,
        meal.totalNutrientsPerDayId);

    return _mealNutrientsRepository.upsert(mealNutrients);
  }
}
