import 'dart:async';
import 'dart:math';

import 'package:calorie_counter/ui/screens/food_details/bloc/food_details_result.dart';
import 'package:calorie_counter/data/local/data_source/i_data_source.dart';
import 'package:calorie_counter/data/local/data_source/result.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/repository.dart';
import 'package:calorie_counter/util/constant/meal_type.dart';
import 'package:calorie_counter/util/extension/ext_meal_nutrients_list.dart';

class MainDataSource implements DataSource {
  final Repository<Food> _foodRepo;
  final Repository<MealNutrients> _mealNutrientsRepo;
  final TotalNutrientsRepository _totalNutrientsPerDayRepo;

  MainDataSource(this._totalNutrientsPerDayRepo, this._foodRepo, this._mealNutrientsRepo);

  @override
  Future<Result<List<Food>>> getAllFood(int mealId) async {
    var listOfFood = await _foodRepo.findAllDataWith(mealId) ?? List<Food>.empty();
    return Success<List<Food>>(listOfFood);
  }

  @override
  Future<Result<List<MealNutrients>>> getAllMealNutrients(
      int totalNutrientsPerDayId, String date) async {
    List<MealNutrients>? listOfMealNutrients =
        await _mealNutrientsRepo.findAllDataWith(totalNutrientsPerDayId);

    if (listOfMealNutrients == null) {
      List<MealNutrients> listOfMealNutrients = [];

      listOfMealNutrients
          .add(_createDefaultMealNutrients(totalNutrientsPerDayId, MealType.BREAKFAST, date));
      listOfMealNutrients
          .add(_createDefaultMealNutrients(totalNutrientsPerDayId, MealType.LUNCH, date));
      listOfMealNutrients
          .add(_createDefaultMealNutrients(totalNutrientsPerDayId, MealType.DINNER, date));
      listOfMealNutrients
          .add(_createDefaultMealNutrients(totalNutrientsPerDayId, MealType.SNACK, date));
    } else {
      if (!listOfMealNutrients.containsType(MealType.BREAKFAST)) {
        listOfMealNutrients
            .add(_createDefaultMealNutrients(totalNutrientsPerDayId, MealType.BREAKFAST, date));
      }

      if (!listOfMealNutrients.containsType(MealType.LUNCH)) {
        listOfMealNutrients
            .add(_createDefaultMealNutrients(totalNutrientsPerDayId, MealType.LUNCH, date));
      }

      if (!listOfMealNutrients.containsType(MealType.DINNER)) {
        listOfMealNutrients
            .add(_createDefaultMealNutrients(totalNutrientsPerDayId, MealType.DINNER, date));
      }

      if (!listOfMealNutrients.containsType(MealType.SNACK)) {
        listOfMealNutrients
            .add(_createDefaultMealNutrients(totalNutrientsPerDayId, MealType.SNACK, date));
      }

      for (var mealNutrients in listOfMealNutrients) {
        mealNutrients.date = date;
      }

      listOfMealNutrients.sort((a, b) => a.type!.compareTo(b.type!));
    }

    return Success<List<MealNutrients>>(listOfMealNutrients ?? List.empty());
  }

  @override
  Future<Result<TotalNutrientsPerDay>> getTotalNutrientsPerDay(String date) async {
    final totalNutrientsPerDay = await _totalNutrientsPerDayRepo.getTotalNutrientsByDate(date);
    if (totalNutrientsPerDay == null) {
      final id = await _totalNutrientsPerDayRepo.getRowCount();
      final currentId = id + 1;

      return Success<TotalNutrientsPerDay>(TotalNutrientsPerDay(currentId, date, 0, 0, 0, 0));
    }
    return Success<TotalNutrientsPerDay>(totalNutrientsPerDay);
  }

  @override
  Future<Result> removeFood(int mealId, Food food) async {
    final numberOfServings = food.numOfServings!;

    final calories = food.calories! * numberOfServings;
    final carbs = food.carbs! * numberOfServings;
    final fat = food.fat! * numberOfServings;
    final protein = food.protein! * numberOfServings;

    final currentMeal = await (_mealNutrientsRepo.getDataById(mealId) as FutureOr<MealNutrients>);

    var totalNutrientsPerDayId = currentMeal.totalNutrientsPerDayId ?? -1;
    await _removeFoodFromTotalNutrients(totalNutrientsPerDayId, calories, carbs, fat, protein);

    _removeFoodFromMealNutrients(currentMeal, calories, carbs, fat, protein);

    _foodRepo.remove(food);
    return Success(null);
  }

  @override
  Future<Result<MealNutrients>> updateOrInsertFood(
      MealNutrients mealNutrients, Food food, int newCount) async {
    var totalNutrientsPerDay = await _updateTotalNutrients(mealNutrients, food, newCount);
    var updatedMealNutrients =
        await _updateMeal(totalNutrientsPerDay.id ?? -1, food, mealNutrients, newCount);
    await _insertFood(updatedMealNutrients.id ?? -1, food, newCount);

    return Success(updatedMealNutrients);
  }

  MealNutrients _createDefaultMealNutrients(int? totalNutrientsPerDayId, int type, String date) {
    return MealNutrients(0, 0, 0, 0, 0, type, totalNutrientsPerDayId, date: date);
  }

  Future _removeFoodFromTotalNutrients(
      int totalNutrientsId, int calories, int carbs, int fat, int protein) async {
    final TotalNutrientsPerDay? totalNutrientsPerDay =
        await _totalNutrientsPerDayRepo.getDataById(totalNutrientsId);

    final updatedTotalNutrients = TotalNutrientsPerDay(
        totalNutrientsPerDay?.id,
        totalNutrientsPerDay?.date,
        totalNutrientsPerDay?.calories ?? 0 - calories,
        totalNutrientsPerDay?.carbs ?? 0 - carbs,
        totalNutrientsPerDay?.fat ?? 0 - fat,
        totalNutrientsPerDay?.protein ?? 0 - protein);

    return _totalNutrientsPerDayRepo.upsert(updatedTotalNutrients);
  }

  Future _removeFoodFromMealNutrients(
      MealNutrients meal, int calories, int carbs, int fat, int protein) async {
    final mealNutrients = MealNutrients(meal.id, meal.calories! - calories, meal.carbs! - carbs,
        meal.fat! - fat, meal.protein! - protein, meal.type, meal.totalNutrientsPerDayId);

    _mealNutrientsRepo.upsert(mealNutrients);
  }

  FoodDetailsCountResult _calculateTheFoodDetails(Food food, int count) {
    final newCalories = food.calories! * count;
    final newCarbs = food.carbs! * count;
    final newFat = food.fat! * count;
    final newProtein = food.protein! * count;

    return FoodDetailsCountResult(newCalories, newCarbs, newFat, newProtein, count);
  }

  Future<TotalNutrientsPerDay> _updateTotalNutrients(
      MealNutrients mealNutrients, Food? food, int? newCount) async {
    var totalNutrientsPerDay =
        await _totalNutrientsPerDayRepo.getTotalNutrientsByDate(mealNutrients.date);

    if (totalNutrientsPerDay == null) {
      //  Add New Food on New TotalNutrients
      var totalNutrientsId = mealNutrients.totalNutrientsPerDayId;

      totalNutrientsPerDay = TotalNutrientsPerDay(
          totalNutrientsId,
          mealNutrients.date,
          food!.calories! * newCount!,
          food.carbs! * newCount,
          food.fat! * newCount,
          food.protein! * newCount);

      _totalNutrientsPerDayRepo.upsert(totalNutrientsPerDay);
    } else {
      var totalNutrientsId = totalNutrientsPerDay.id;

      if (food!.id == -1) {
        // New Food on Current TotalNutrients
        final calculatedFoodDetails = _calculateTheFoodDetails(food, newCount!);

        final newCalories = totalNutrientsPerDay.calories! + calculatedFoodDetails.calories;
        final newCarbs = totalNutrientsPerDay.carbs! + calculatedFoodDetails.carbs;
        final newFat = totalNutrientsPerDay.fat! + calculatedFoodDetails.fat;
        final newProtein = totalNutrientsPerDay.protein! + calculatedFoodDetails.protein;

        final updateTotalNutrients = TotalNutrientsPerDay(
            totalNutrientsId, mealNutrients.date, newCalories, newCarbs, newFat, newProtein);

        _totalNutrientsPerDayRepo.upsert(updateTotalNutrients);
      } else {
        //  Old Food
        int newCalories = 0;
        int newCarbs = 0;
        int newFat = 0;
        int newProtein = 0;
        if (newCount! > food.numOfServings!) {
          final updateCount = newCount - food.numOfServings!;
          final calculatedFoodDetails = _calculateTheFoodDetails(food, updateCount);
          newCalories = totalNutrientsPerDay.calories! + calculatedFoodDetails.calories;
          newCarbs = totalNutrientsPerDay.carbs! + calculatedFoodDetails.carbs;
          newFat = totalNutrientsPerDay.fat! + calculatedFoodDetails.fat;
          newProtein = totalNutrientsPerDay.protein! + calculatedFoodDetails.protein;
        } else if (newCount < food.numOfServings!) {
          final updateCount = food.numOfServings! - newCount;
          final calculatedFoodDetails = _calculateTheFoodDetails(food, updateCount);
          newCalories = totalNutrientsPerDay.calories! - calculatedFoodDetails.calories;
          newCarbs = totalNutrientsPerDay.carbs! - calculatedFoodDetails.carbs;
          newFat = totalNutrientsPerDay.fat! - calculatedFoodDetails.fat;
          newProtein = totalNutrientsPerDay.protein! - calculatedFoodDetails.protein;
        }

        final newTotalNutrientsPerDay = TotalNutrientsPerDay(
            totalNutrientsId, totalNutrientsPerDay.date, newCalories, newCarbs, newFat, newProtein);

        _totalNutrientsPerDayRepo.upsert(newTotalNutrientsPerDay);
      }
    }
    return totalNutrientsPerDay;
  }

  Future<MealNutrients> _updateMeal(
      int totalNutrientsPerDayId, Food food, MealNutrients mealNutrients, int newCount) async {
    var currentMealNutrients = await _mealNutrientsRepo.getDataById(mealNutrients.id ?? -1);

    if (currentMealNutrients == null) {
      var id = await _mealNutrientsRepo.getRowCount();
      id += 1;
      final calculatedFoodDetails = _calculateTheFoodDetails(food, newCount);

      currentMealNutrients = MealNutrients(
          id,
          calculatedFoodDetails.calories,
          calculatedFoodDetails.carbs,
          calculatedFoodDetails.fat,
          calculatedFoodDetails.protein,
          mealNutrients.type,
          totalNutrientsPerDayId,
          date: mealNutrients.date);
    } else {
      if (food.id == -1) {
        // New Food
        final calculatedFoodDetails = _calculateTheFoodDetails(food, newCount);
        final newCalories = currentMealNutrients.calories! + calculatedFoodDetails.calories;
        final newCarbs = currentMealNutrients.carbs! + calculatedFoodDetails.carbs;
        final newFat = currentMealNutrients.fat! + calculatedFoodDetails.fat;
        final newProtein = currentMealNutrients.protein! + calculatedFoodDetails.protein;

        currentMealNutrients = MealNutrients(currentMealNutrients.id, newCalories, newCarbs, newFat,
            newProtein, currentMealNutrients.type, totalNutrientsPerDayId,
            date: mealNutrients.date);
      } else {
        // Old Food
        int? newCalories;
        int? newCarbs;
        int? newFat;
        int? newProtein;
        if (newCount > food.numOfServings!) {
          // Add
          final updateCount = newCount - food.numOfServings!;
          final calculatedFoodDetails = _calculateTheFoodDetails(food, updateCount);
          newCalories = currentMealNutrients.calories! + calculatedFoodDetails.calories;
          newCarbs = currentMealNutrients.carbs! + calculatedFoodDetails.carbs;
          newFat = currentMealNutrients.fat! + calculatedFoodDetails.fat;
          newProtein = currentMealNutrients.protein! + calculatedFoodDetails.protein;
        } else if (newCount < food.numOfServings!) {
          //  Subtract
          final updateCount = food.numOfServings! - newCount;
          final calculatedFoodDetails = _calculateTheFoodDetails(food, updateCount);
          newCalories = currentMealNutrients.calories! - calculatedFoodDetails.calories;
          newCarbs = currentMealNutrients.carbs! - calculatedFoodDetails.carbs;
          newFat = currentMealNutrients.fat! - calculatedFoodDetails.fat;
          newProtein = currentMealNutrients.protein! - calculatedFoodDetails.protein;
        }

        currentMealNutrients = MealNutrients(currentMealNutrients.id, newCalories, newCarbs, newFat,
            newProtein, currentMealNutrients.type, totalNutrientsPerDayId,
            date: mealNutrients.date);
      }
    }
    _mealNutrientsRepo.upsert(currentMealNutrients);
    return currentMealNutrients;
  }

  Future _insertFood(int mealId, Food food, int newCount) async {
    final currentFood = await _foodRepo.getDataById(food.id ?? -1);
    Food updateFood;

    if (currentFood == null) {
      var rng = new Random();
      var generatedId = rng.nextInt(900000) + 100000;
      updateFood = Food(generatedId, mealId, food.name, newCount, food.brandName, food.calories,
          food.carbs, food.fat, food.protein);
    } else {
      updateFood = Food(currentFood.id, mealId, food.name, newCount, food.brandName, food.calories,
          food.carbs, food.fat, food.protein);
    }
    return _foodRepo.upsert(updateFood);
  }
}
