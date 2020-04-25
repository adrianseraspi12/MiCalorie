import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/breakfast_nutrients.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/breakfast_repository.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:calorie_counter/data/model/client_food.dart';
import 'package:calorie_counter/data/model/meal_summary.dart';
import 'package:calorie_counter/util/extension/ext_nutrient_list.dart';

import 'bloc.dart';

class FoodDetailsBloc implements Bloc {

  FoodRepository _foodRepository;
  BreakfastRepository _breakfastNutrients;
  TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;


  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _foodRepository = FoodRepository(database.foodDao);
    _breakfastNutrients = BreakfastRepository(database.breakfastNutrientsDao);
    _totalNutrientsPerDayRepository = TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
  }

  Future<String> addFood(MealSummary mealSummary, ClientFood food) async {
    updateTotalNutrients(mealSummary, food);
    updateMeal(mealSummary, food);
    return 'Food Added';
    //  Follow these steps:
    //  1.  get first food nutrients
    //  2.  set to mealSummary
    //  1.  save the mealSummary
    //  2.  get the itemId of mealSummary
    //  3.  set it to Food
    //  4.  save it to database

    //  set id to food
    // return String if successful
    // throw exception if not
    
  }
    
  void updateTotalNutrients(MealSummary mealSummary, ClientFood food) async {
    final totalNutrientsPerDay = await _totalNutrientsPerDayRepository.getTotalNutrientsByDate(mealSummary.date);

    if (totalNutrientsPerDay == null) {
      final currentTotalNutrients = TotalNutrientsPerDay(mealSummary.totalNutrientsId,
        mealSummary.date, 
        food.nutrients.getNutrient(NutrientType.calories).toInt(),
        food.nutrients.getNutrient(NutrientType.carbs),
        food.nutrients.getNutrient(NutrientType.fat),
        food.nutrients.getNutrient(NutrientType.protein));
      
      _totalNutrientsPerDayRepository.upsert(currentTotalNutrients);
    }
    else {
      //  update carbs calories
    }
  }

  void updateMeal(MealSummary mealSummary, ClientFood food) async {
    if (mealSummary.name == "Breakfast") {
      final breakfastNutrients = _breakfastNutrients.getBreakfast(mealSummary.id);
      int currentId;

      if (breakfastNutrients == null) {
        final id = await _breakfastNutrients.getTotalBreakfastCount();
        currentId = id + 1;

        final breakfast = BreakfastNutrients(currentId,
        food.nutrients.getNutrient(NutrientType.calories).toInt(),
        food.nutrients.getNutrient(NutrientType.carbs),
        food.nutrients.getNutrient(NutrientType.fat),
        food.nutrients.getNutrient(NutrientType.protein),
        mealSummary.totalNutrientsId);

        _breakfastNutrients.upsert(breakfast);
      }

      insertFood(currentId, food);
    }
  }

  void insertFood(int id, ClientFood clientFood) async {
    final foodId = await _foodRepository.getAllFoodCount();
    final currentFoodId = foodId + 1;

    final food = Food(currentFoodId,
    id, 
    clientFood.name, 
    clientFood.numberOfServings, 
    clientFood.servingSize, 
    clientFood.nutrients.getNutrient(NutrientType.calories).toInt(),
    clientFood.nutrients.getNutrient(NutrientType.carbs),
    clientFood.nutrients.getNutrient(NutrientType.fat),
    clientFood.nutrients.getNutrient(NutrientType.protein));

    _foodRepository.upsert(food);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }


}