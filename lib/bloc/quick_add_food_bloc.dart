import 'dart:math';

import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:calorie_counter/util/extension/ext_number_rounding.dart';

import 'bloc.dart';

class QuickAddFoodBloc implements Bloc {

  final _resultController = PublishSubject<QuickAddResult>();

  Stream<QuickAddResult> get resultStream => _resultController.stream;

  MealNutrientsRepository _mealNutrientsRepository;
  FoodRepository _foodRepository;
  TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;

  int calories;
  int carbs;
  int protein;
  int fat;
  int quantity;
  String name;
  String brand;

  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _foodRepository = FoodRepository(database.foodDao);
    _mealNutrientsRepository = MealNutrientsRepository(database.mealNutrientsDao);
    _totalNutrientsPerDayRepository = TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
  }

  void addFood(
    MealNutrients mealNutrients,
    String name, 
    String brand, 
    String quantity, 
    String calories, 
    String carbs,
    String fat,
    String protein) {


    this.name = name;
    this.quantity = int.parse(quantity = quantity.isEmpty ? '0': quantity, radix: 10);
    this.calories = int.parse(calories = calories.isEmpty ? '0': calories, radix: 10);
    this.carbs = int.parse(carbs = carbs.isEmpty ? '0': carbs, radix: 10);
    this.fat = int.parse(fat = fat.isEmpty ? '0': fat,radix: 10);
    this.protein = int.parse(protein = protein.isEmpty ? '0': protein, radix: 10);

    if (brand.isEmpty) {
      this.brand = 'Generic';
    }
    else {
      this.brand = brand;
    }

    if (name.isEmpty) {
      _resultController.sink.add(QuickAddResult(
        result: Result.onFailed, 
        errorMessage: 'Name should not be empty')
      );
      return;
    }

    if (this.quantity == 0) {
      _resultController.sink.add(QuickAddResult(
        result: Result.onFailed, 
        errorMessage: 'Quantity should be more than 0')
      );
      return;
    }

    if (calories.isEmpty || calories == '0') {
      _resultController.sink.add(QuickAddResult(
        result: Result.onFailed, 
        errorMessage: 'Calories should be more than 0')
      );
      return;
    }
    
    _updateNutrients(mealNutrients);
  }

  void _updateNutrients(MealNutrients mealNutrients) async {
    var totalNutrientsPerDay = await _totalNutrientsPerDayRepository.getTotalNutrientsByDate(mealNutrients.date);
    var totalNutrientsId;

    if (totalNutrientsPerDay == null) {
      totalNutrientsId = mealNutrients.totalNutrientsPerDayId;
      
      final currentTotalNutrients = TotalNutrientsPerDay(
        mealNutrients.totalNutrientsPerDayId,
        mealNutrients.date, 
        calories,
        carbs,
        fat,
        protein
      );
      
      _totalNutrientsPerDayRepository.upsert(currentTotalNutrients);
    }
    else {
      totalNutrientsId = totalNutrientsPerDay.id;

      final newCalories = totalNutrientsPerDay.calories + calories;
      final newCarbs = totalNutrientsPerDay.carbs + carbs;
      final newFat = totalNutrientsPerDay.fat + fat;
      final newProtein = totalNutrientsPerDay.protein + protein;

      final updateTotalNutrients = TotalNutrientsPerDay(
          mealNutrients.totalNutrientsPerDayId,
          mealNutrients.date, 
          newCalories,
          newCarbs,
          newFat,
          newProtein
      );

      _totalNutrientsPerDayRepository.upsert(updateTotalNutrients);
    }

    _updateMeal(totalNutrientsId, mealNutrients);
  }

  void _updateMeal(int totalNutrientsId, MealNutrients mealNutrients) async {
    final currentMealNutrients = await _mealNutrientsRepository.getMeal(mealNutrients.id);
  
    if (currentMealNutrients == null) {
      var id = await _mealNutrientsRepository.getAllMealCount();
      id += 1;

      final newMealNutrients = MealNutrients(
        id, 
        calories,
        carbs,
        fat,
        protein,
        mealNutrients.type, 
        totalNutrientsId,
        date: mealNutrients.date);

      _mealNutrientsRepository.upsert(newMealNutrients);
      _insertFood(newMealNutrients);
    }
    else {
      final newCalories = currentMealNutrients.calories + calories;
      final newCarbs = currentMealNutrients.carbs + carbs;
      final newFat = currentMealNutrients.fat + fat;
      final newProtein = currentMealNutrients.protein + protein;

      final updateMealNutrients = MealNutrients(
        currentMealNutrients.id, 
        newCalories, 
        newCarbs, 
        newFat, 
        newProtein, 
        currentMealNutrients.type, 
        totalNutrientsId,
        date: mealNutrients.date
      );

      _mealNutrientsRepository.upsert(updateMealNutrients);
      _insertFood(updateMealNutrients);
    }
  }

  void _insertFood(MealNutrients mealNutrients) async {
    var rng = new Random();
    var generatedId = rng.nextInt(900000) + 100000;

    final newCalories = calories / quantity;
    final newCarbs = carbs / quantity;
    final newFat = fat / quantity;
    final newProtein = protein / quantity;

    final updateFood = Food(
      generatedId,
      mealNutrients.id, 
      name,
      quantity, 
      brand,
      newCalories.roundTo(0).toInt(),
      newCarbs.roundTo(0).toInt(),
      newFat.roundTo(0).toInt(),
      newProtein.roundTo(0).toInt()
    );

    await _foodRepository
      .upsert(updateFood)
      .then( (_) => _resultController.sink.add(QuickAddResult(result: Result.onSuccess)));
  }


  @override
  void dispose() {
    _resultController.close();
  }

}

class QuickAddResult {

  Result result;
  String errorMessage;

  QuickAddResult({Key key, this.result, this.errorMessage});

}

enum Result {

  onSuccess,
  onFailed

}