import 'package:calorie_counter/data/local/data_source/result.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';

abstract class DataSource {
  Future<Result<TotalNutrientsPerDay>> getTotalNutrientsPerDay(String date);

  Future<Result<List<MealNutrients>>> getAllMealNutrients(
      int totalNutrientsPerDayId, String date);

  Future<Result<List<Food>>> getAllFood(int mealId);

  Future<Result> removeFood(int mealId, Food food);

  Future<Result<MealNutrients>> updateOrInsertFood(
      MealNutrients mealNutrients, Food food, int newCount);
}
