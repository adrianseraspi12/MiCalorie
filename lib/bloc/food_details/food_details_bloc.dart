import 'dart:math';

import 'package:calorie_counter/bloc/food_details/food_details_result.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'food_details_event.dart';

part 'food_details_state.dart';

class FoodDetailsBloc extends Bloc<FoodDetailsEvent, FoodDetailsState> {
  final MealNutrientsRepository _mealNutrientsRepository;
  final FoodRepository _foodRepository;
  final TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;

  final Food _food;
  int currentCount = 1;
  int currentCalories = 0;
  int currentCarbs = 0;
  int currentFat = 0;
  int currentProtein = 0;

  FoodDetailsBloc(this._food, this._mealNutrientsRepository,
      this._foodRepository, this._totalNutrientsPerDayRepository)
      : super(InitialFoodDetailsState()) {
    currentCount = _food.numOfServings;
    currentCalories = _food.calories * currentCount;
    currentCarbs = _food.carbs * currentCount;
    currentFat = _food.fat * currentCount;
    currentProtein = _food.protein * currentCount;
  }

  @override
  Stream<FoodDetailsState> mapEventToState(FoodDetailsEvent event) async* {
    if (event is SetupFoodDetailsEvent) {
      yield LoadingFoodDetailsState();
      yield LoadedFoodDetailsState(currentCalories, currentCarbs, currentFat,
          currentProtein, currentCount);
    } else if (event is IncrementEvent) {
      yield LoadingFoodDetailsState();
      currentCount += 1;
      currentCalories = _food.calories * currentCount;
      currentCarbs = _food.carbs * currentCount;
      currentFat = _food.fat * currentCount;
      currentProtein = _food.protein * currentCount;

      yield LoadedFoodDetailsState(currentCalories, currentCarbs, currentFat,
          currentProtein, currentCount);
    } else if (event is DecrementEvent) {
      if (currentCount >= 2) {
        yield LoadingFoodDetailsState();
        currentCount -= 1;
        currentCalories = _food.calories * currentCount;
        currentCarbs = _food.carbs * currentCount;
        currentFat = _food.fat * currentCount;
        currentProtein = _food.protein * currentCount;

        yield LoadedFoodDetailsState(currentCalories, currentCarbs, currentFat,
            currentProtein, currentCount);
      }
    } else if (event is AddFoodEvent) {
      //  Don't save if the old food is not changed
      if (currentCount == _food.numOfServings && _food.id != -1) {
        yield FoodSaveState(event.mealNutrients, '');
        return;
      }
      var totalNutrientsPerDay =
          await _updateTotalNutrients(event.mealNutrients);
      var mealNutrients =
          await _updateMeal(totalNutrientsPerDay.id, event.mealNutrients);
      var message = await _insertFood(mealNutrients);
      yield FoodSaveState(mealNutrients, message);
    }
  }

  Future<TotalNutrientsPerDay> _updateTotalNutrients(
      MealNutrients mealNutrients) async {
    var totalNutrientsPerDay = await _totalNutrientsPerDayRepository
        .getTotalNutrientsByDate(mealNutrients.date);

    if (totalNutrientsPerDay == null) {
      var totalNutrientsId = mealNutrients.totalNutrientsPerDayId;

      totalNutrientsPerDay = TotalNutrientsPerDay(
          totalNutrientsId,
          mealNutrients.date,
          currentCalories,
          currentCarbs,
          currentFat,
          currentProtein);

      await _totalNutrientsPerDayRepository.upsert(totalNutrientsPerDay);
    } else {
      var totalNutrientsId = totalNutrientsPerDay.id;

      if (_food.id == -1) {
        // New Food
        final newCalories = totalNutrientsPerDay.calories + currentCalories;
        final newCarbs = totalNutrientsPerDay.carbs + currentCarbs;
        final newFat = totalNutrientsPerDay.fat + currentFat;
        final newProtein = totalNutrientsPerDay.protein + currentProtein;

        final updateTotalNutrients = TotalNutrientsPerDay(totalNutrientsId,
            mealNutrients.date, newCalories, newCarbs, newFat, newProtein);

        await _totalNutrientsPerDayRepository.upsert(updateTotalNutrients);
      } else {
        //  Old Food
        int newCalories;
        int newCarbs;
        int newFat;
        int newProtein;
        if (currentCount > _food.numOfServings) {
          final newCount = currentCount - _food.numOfServings;
          final calculatedFoodDetails = _calculateTheFoodDetails(newCount);
          newCalories =
              totalNutrientsPerDay.calories + calculatedFoodDetails.calories;
          newCarbs = totalNutrientsPerDay.carbs + calculatedFoodDetails.carbs;
          newFat = totalNutrientsPerDay.fat + calculatedFoodDetails.fat;
          newProtein =
              totalNutrientsPerDay.protein + calculatedFoodDetails.protein;
        } else if (currentCount < _food.numOfServings) {
          final newCount = _food.numOfServings - currentCount;
          final calculatedFoodDetails = _calculateTheFoodDetails(newCount);
          newCalories =
              totalNutrientsPerDay.calories - calculatedFoodDetails.calories;
          newCarbs = totalNutrientsPerDay.carbs - calculatedFoodDetails.carbs;
          newFat = totalNutrientsPerDay.fat - calculatedFoodDetails.fat;
          newProtein =
              totalNutrientsPerDay.protein - calculatedFoodDetails.protein;
        }

        final newTotalNutrientsPerDay = TotalNutrientsPerDay(
            totalNutrientsId,
            totalNutrientsPerDay.date,
            newCalories,
            newCarbs,
            newFat,
            newProtein);

        await _totalNutrientsPerDayRepository.upsert(newTotalNutrientsPerDay);
      }
    }
    return totalNutrientsPerDay;
  }

  Future<MealNutrients> _updateMeal(
      int totalNutrientsPerDayId, MealNutrients mealNutrients) async {
    var currentMealNutrients =
        await _mealNutrientsRepository.getMeal(mealNutrients.id);

    if (currentMealNutrients == null) {
      var id = await _mealNutrientsRepository.getAllMealCount();
      id += 1;

      currentMealNutrients = MealNutrients(
          id,
          currentCalories,
          currentCarbs,
          currentFat,
          currentProtein,
          mealNutrients.type,
          totalNutrientsPerDayId,
          date: mealNutrients.date);

      await _mealNutrientsRepository.upsert(currentMealNutrients);
    } else {
      if (_food.id == -1) {
        // New Food
        final newCalories = currentMealNutrients.calories + currentCalories;
        final newCarbs = currentMealNutrients.carbs + currentCarbs;
        final newFat = currentMealNutrients.fat + currentFat;
        final newProtein = currentMealNutrients.protein + currentProtein;

        currentMealNutrients = MealNutrients(
            currentMealNutrients.id,
            newCalories,
            newCarbs,
            newFat,
            newProtein,
            currentMealNutrients.type,
            totalNutrientsPerDayId,
            date: mealNutrients.date);

        await _mealNutrientsRepository.upsert(currentMealNutrients);
      } else {
        // Old Food
        int newCalories;
        int newCarbs;
        int newFat;
        int newProtein;
        if (currentCount > _food.numOfServings) {
          // Add
          final newCount = currentCount - _food.numOfServings;
          final calculatedFoodDetails = _calculateTheFoodDetails(newCount);
          newCalories =
              currentMealNutrients.calories + calculatedFoodDetails.calories;
          newCarbs = currentMealNutrients.carbs + calculatedFoodDetails.carbs;
          newFat = currentMealNutrients.fat + calculatedFoodDetails.fat;
          newProtein =
              currentMealNutrients.protein + calculatedFoodDetails.protein;
        } else if (currentCount < _food.numOfServings) {
          //  Subtract
          final newCount = _food.numOfServings - currentCount;
          final calculatedFoodDetails = _calculateTheFoodDetails(newCount);
          newCalories =
              currentMealNutrients.calories - calculatedFoodDetails.calories;
          newCarbs = currentMealNutrients.carbs - calculatedFoodDetails.carbs;
          newFat = currentMealNutrients.fat - calculatedFoodDetails.fat;
          newProtein =
              currentMealNutrients.protein - calculatedFoodDetails.protein;
        }

        currentMealNutrients = MealNutrients(
            currentMealNutrients.id,
            newCalories,
            newCarbs,
            newFat,
            newProtein,
            currentMealNutrients.type,
            totalNutrientsPerDayId,
            date: mealNutrients.date);
        await _mealNutrientsRepository.upsert(currentMealNutrients);
      }
    }
    return currentMealNutrients;
  }

  Future<String> _insertFood(MealNutrients mealNutrients) async {
    final currentFood = await _foodRepository.getFoodById(_food.id);
    Food updateFood;
    String message;

    if (currentFood == null) {
      var rng = new Random();
      var generatedId = rng.nextInt(900000) + 100000;

      message = 'Food added';

      updateFood = Food(
          generatedId,
          mealNutrients.id,
          _food.name,
          currentCount,
          _food.brandName,
          _food.calories,
          _food.carbs,
          _food.fat,
          _food.protein);
    } else {
      message = 'Food saved';
      updateFood = Food(
          currentFood.id,
          mealNutrients.id,
          _food.name,
          currentCount,
          _food.brandName,
          _food.calories,
          _food.carbs,
          _food.fat,
          _food.protein);
    }
    await _foodRepository.upsert(updateFood);
    return message;
  }

  FoodDetailsCountResult _calculateTheFoodDetails(int count) {
    final newCalories = _food.calories * count;
    final newCarbs = _food.carbs * count;
    final newFat = _food.fat * count;
    final newProtein = _food.protein * count;

    return FoodDetailsCountResult(
        newCalories, newCarbs, newFat, newProtein, count);
  }
}
