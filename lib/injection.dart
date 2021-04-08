import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/data_source/main_data_source.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';

class Injection {
  static MainDataSource provideMainDataSource(AppDatabase appDatabase) {
    var totalNutrientsPerDayRepo =
        TotalNutrientsPerDayRepository(appDatabase.totalNutrientsPerDayDao);
    var foodRepo = FoodRepository(appDatabase.foodDao);
    var mealNutrientsRepo =
        MealNutrientsRepository(appDatabase.mealNutrientsDao);

    return MainDataSource(
        totalNutrientsPerDayRepo, foodRepo, mealNutrientsRepo);
  }
}
