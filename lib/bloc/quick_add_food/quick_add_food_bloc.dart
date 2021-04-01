import 'dart:ffi';
import 'dart:math';

import 'package:calorie_counter/bloc/quick_add_food/quick_add_food_text_field_type.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:calorie_counter/util/constant/strings.dart';
import 'package:calorie_counter/util/exceptions/common_exceptions.dart';
import 'package:calorie_counter/util/extension/ext_number_rounding.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quick_add_food_event.dart';

part 'quick_add_food_state.dart';

class QuickAddFoodBloc extends Bloc<QuickAddFoodEvent, QuickAddFoodState> {
  QuickAddFoodBloc(this._mealNutrientsRepository, this._foodRepository,
      this._totalNutrientsPerDayRepository, this._mealNutrients)
      : super(InitialQuickAddFoodState());

  final MealNutrientsRepository _mealNutrientsRepository;
  final FoodRepository _foodRepository;
  final TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;
  final MealNutrients _mealNutrients;

  int _calories = 0;
  int _carbs = 0;
  int _protein = 0;
  int _fat = 0;
  int _quantity = 1;
  String _name = '';
  String _brand = '';

  @override
  Stream<QuickAddFoodState> mapEventToState(QuickAddFoodEvent event) async* {
    if (event is AddFoodEvent) {
      var errorMessage = _hasErrorMessage(event);
      if (errorMessage.isNotEmpty) {
        yield ErrorQuickAddFoodState(errorMessage);
        return;
      }

      yield LoadingQuickAddFoodState();

      try {
        var totalNutrientsId = await _updateNutrients(_mealNutrients);
        var newMealNutrients =
            await _updateMeal(totalNutrientsId, _mealNutrients);
        await _insertFood(newMealNutrients);
        yield LoadedQuickAddFoodState();
      } on UnIdentifiedException {
        yield ErrorQuickAddFoodState(ErrorMessage.unableToSaveFoods);
      }
    }
  }

  void updateText(String text, QuickAddFoodTextFieldType type) {
    switch (type) {
      case QuickAddFoodTextFieldType.name:
        this._name = text;
        break;
      case QuickAddFoodTextFieldType.brand:
        this._brand = text;
        break;
      case QuickAddFoodTextFieldType.quantity:
        this._quantity = _parse(text);
        break;
      case QuickAddFoodTextFieldType.calories:
        this._calories = _parse(text);
        break;
      case QuickAddFoodTextFieldType.carbs:
        this._carbs = _parse(text);
        break;
      case QuickAddFoodTextFieldType.fat:
        this._fat = _parse(text);
        break;
      case QuickAddFoodTextFieldType.protein:
        this._protein = _parse(text);
        break;
    }
  }

  int _parse(String stringNum) {
    return int.parse(stringNum.isEmpty ? '0' : stringNum, radix: 10);
  }

  String _hasErrorMessage(AddFoodEvent event) {
    if (this._name.isEmpty) {
      return ErrorMessage.nameIsEmpty;
    }

    if (this._quantity == 0) {
      return ErrorMessage.quantityIsZero;
    }

    if (this._calories == 0) {
      return ErrorMessage.calorieIsZero;
    }

    return '';
  }

  Future<int> _updateNutrients(MealNutrients mealNutrients) async {
    var totalNutrientsPerDay = await _totalNutrientsPerDayRepository
        .getTotalNutrientsByDate(mealNutrients.date);
    var totalNutrientsId;

    if (totalNutrientsPerDay == null) {
      totalNutrientsId = mealNutrients.totalNutrientsPerDayId;

      final currentTotalNutrients = TotalNutrientsPerDay(
          mealNutrients.totalNutrientsPerDayId,
          mealNutrients.date,
          _calories,
          _carbs,
          _fat,
          _protein);

      var isSuccess = await _totalNutrientsPerDayRepository
          .futureUpsert(currentTotalNutrients);
      if (!isSuccess) {
        throw UnIdentifiedException();
      } else {
        return totalNutrientsId;
      }
    } else {
      totalNutrientsId = totalNutrientsPerDay.id;

      final newCalories = totalNutrientsPerDay.calories + _calories;
      final newCarbs = totalNutrientsPerDay.carbs + _carbs;
      final newFat = totalNutrientsPerDay.fat + _fat;
      final newProtein = totalNutrientsPerDay.protein + _protein;

      final updateTotalNutrients = TotalNutrientsPerDay(
          mealNutrients.totalNutrientsPerDayId,
          mealNutrients.date,
          newCalories,
          newCarbs,
          newFat,
          newProtein);

      var isSuccess = await _totalNutrientsPerDayRepository
          .futureUpsert(updateTotalNutrients);
      if (!isSuccess) {
        throw UnIdentifiedException();
      } else {
        return totalNutrientsId;
      }
    }
  }

  Future<MealNutrients> _updateMeal(
      int totalNutrientsId, MealNutrients mealNutrients) async {
    final currentMealNutrients =
        await _mealNutrientsRepository.getMeal(mealNutrients.id);

    MealNutrients newMealNutrients;

    if (currentMealNutrients == null) {
      var id = await _mealNutrientsRepository.getAllMealCount();
      id += 1;

      newMealNutrients = MealNutrients(id, _calories, _carbs, _fat, _protein,
          mealNutrients.type, totalNutrientsId,
          date: mealNutrients.date);

      var isSuccess =
          await _mealNutrientsRepository.futureUpsert(newMealNutrients);
      if (!isSuccess) {
        throw UnIdentifiedException();
      }
    } else {
      final newCalories = currentMealNutrients.calories + _calories;
      final newCarbs = currentMealNutrients.carbs + _carbs;
      final newFat = currentMealNutrients.fat + _fat;
      final newProtein = currentMealNutrients.protein + _protein;

      newMealNutrients = MealNutrients(
          currentMealNutrients.id,
          newCalories,
          newCarbs,
          newFat,
          newProtein,
          currentMealNutrients.type,
          totalNutrientsId,
          date: mealNutrients.date);

      var isSuccess =
          await _mealNutrientsRepository.futureUpsert(newMealNutrients);
      if (!isSuccess) {
        throw UnIdentifiedException();
      }
    }
    return newMealNutrients;
  }

  Future<Void> _insertFood(MealNutrients mealNutrients) async {
    var rng = new Random();
    var generatedId = rng.nextInt(900000) + 100000;

    final newCalories = _calories / _quantity;
    final newCarbs = _carbs / _quantity;
    final newFat = _fat / _quantity;
    final newProtein = _protein / _quantity;

    final updateFood = Food(
        generatedId,
        mealNutrients.id,
        _name,
        _quantity,
        _brand,
        newCalories.roundTo(0).toInt(),
        newCarbs.roundTo(0).toInt(),
        newFat.roundTo(0).toInt(),
        newProtein.roundTo(0).toInt());

    var isSuccess = await _foodRepository.futureUpsert(updateFood);

    if (!isSuccess) {
      throw UnIdentifiedException();
    }
  }
}