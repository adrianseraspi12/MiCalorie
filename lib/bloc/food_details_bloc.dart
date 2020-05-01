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

  Future<MealSummary> addFood(MealSummary mealSummary, ClientFood food) async {
    final totalNutrientsId = await updateTotalNutrients(mealSummary, food);
    final breakfastNutrients = await updateMeal(mealSummary, food);
    return MealSummary(
      breakfastNutrients.id,
      mealSummary.name, 
      breakfastNutrients.calories, 
      breakfastNutrients.carbs, 
      breakfastNutrients.fat, 
      breakfastNutrients.protein, 
      mealSummary.date, 
      totalNutrientsId);
  }
    
  Future<int> updateTotalNutrients(MealSummary mealSummary, ClientFood food) async {
    var totalNutrientsPerDay = await _totalNutrientsPerDayRepository.getTotalNutrientsByDate(mealSummary.date);

    if (totalNutrientsPerDay == null) {
      final currentTotalNutrients = TotalNutrientsPerDay(mealSummary.totalNutrientsId,
        mealSummary.date, 
        food.nutrients.getNutrient(NutrientType.calories).toInt(),
        food.nutrients.getNutrient(NutrientType.carbs),
        food.nutrients.getNutrient(NutrientType.fat),
        food.nutrients.getNutrient(NutrientType.protein));
      
      _totalNutrientsPerDayRepository.upsert(currentTotalNutrients);
      return mealSummary.totalNutrientsId;
    }
    else {
      final foodNutrients = food.nutrients;
      final newCalories = totalNutrientsPerDay.calories + foodNutrients.getNutrient(NutrientType.calories).toInt();
      final newCarbs = totalNutrientsPerDay.carbs + foodNutrients.getNutrient(NutrientType.carbs);
      final newFat = totalNutrientsPerDay.fat + foodNutrients.getNutrient(NutrientType.fat);
      final newProtein = totalNutrientsPerDay.protein + foodNutrients.getNutrient(NutrientType.protein);

      final newTotalNutrientsPerDay = TotalNutrientsPerDay(
        totalNutrientsPerDay.id, 
        totalNutrientsPerDay.date, 
        newCalories,
        newCarbs, 
        newFat, 
        newProtein);

      _totalNutrientsPerDayRepository.upsert(newTotalNutrientsPerDay);
      return totalNutrientsPerDay.id;
    }
  }

  Future<BreakfastNutrients> updateMeal(MealSummary mealSummary, ClientFood food) async {
    if (mealSummary.name == "Breakfast") {
      final breakfastNutrients = await _breakfastNutrients.getBreakfast(mealSummary.id);
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
        insertFood(currentId, food);
        return breakfast;
      }
      else {
        final foodNutrients = food.nutrients;
        final newCalories = breakfastNutrients.calories + foodNutrients.getNutrient(NutrientType.calories).toInt();
        final newCarbs = breakfastNutrients.carbs + foodNutrients.getNutrient(NutrientType.carbs);
        final newFat = breakfastNutrients.fat + foodNutrients.getNutrient(NutrientType.fat);
        final newProtein = breakfastNutrients.protein + foodNutrients.getNutrient(NutrientType.protein);

        final newBreakfastNutrients = BreakfastNutrients(
          breakfastNutrients.id, 
          newCalories, 
          newCarbs, 
          newFat, 
          newProtein, 
          breakfastNutrients.totalNutrientsPerDayId);

        _breakfastNutrients.upsert(newBreakfastNutrients);
        insertFood(currentId, food);
        return newBreakfastNutrients;
      }
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

  }


}