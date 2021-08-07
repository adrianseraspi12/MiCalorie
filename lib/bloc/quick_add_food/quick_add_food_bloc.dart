import 'package:calorie_counter/bloc/quick_add_food/quick_add_food_text_field_type.dart';
import 'package:calorie_counter/data/local/data_source/i_data_source.dart';
import 'package:calorie_counter/data/local/data_source/result.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/util/constant/strings.dart';
import 'package:calorie_counter/util/exceptions/common_exceptions.dart';
import 'package:calorie_counter/util/extension/ext_number_rounding.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quick_add_food_event.dart';

part 'quick_add_food_state.dart';

class QuickAddFoodBloc extends Bloc<QuickAddFoodEvent, QuickAddFoodState> {
  QuickAddFoodBloc(this._mealNutrients, this._dataSource) : super(InitialQuickAddFoodState());

  final MealNutrients _mealNutrients;
  final DataSource _dataSource;

  int _calories = 0;
  int _carbs = 0;
  int _protein = 0;
  int _fat = 0;
  int _quantity = 1;
  String _name = '';
  String _brand = 'Generic';

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
        var food = createFood(_mealNutrients.id ?? -1);
        var result = await _dataSource.updateOrInsertFood(_mealNutrients, food, _quantity);

        if (result is Fail) {
          return;
        }
        var updatedMealNutrients = (result as Success<MealNutrients>).data;
        yield LoadedQuickAddFoodState(updatedMealNutrients);
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

  Food createFood(int mealId) {
    final newCalories = _calories / _quantity;
    final newCarbs = _carbs / _quantity;
    final newFat = _fat / _quantity;
    final newProtein = _protein / _quantity;

    return Food(-1, mealId, _name, 1, _brand, newCalories.roundTo(0).toInt(),
        newCarbs.roundTo(0).toInt(), newFat.roundTo(0).toInt(), newProtein.roundTo(0).toInt());
  }
}
