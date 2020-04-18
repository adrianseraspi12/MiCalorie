import 'package:floor/floor.dart';

import 'package:calorie_counter/data/local/dao/breakfast_nutrients_dao.dart';
import 'package:calorie_counter/data/local/dao/dinner_nutrients_dao.dart';
import 'package:calorie_counter/data/local/dao/food_dao.dart';
import 'package:calorie_counter/data/local/dao/lunch_nutrients_dao.dart';
import 'package:calorie_counter/data/local/dao/snack_nutrients_dao.dart';
import 'package:calorie_counter/data/local/dao/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/breakfast_nutrients.dart';
import 'package:calorie_counter/data/local/entity/dinner_nutrients.dart';
import 'package:calorie_counter/data/local/entity/lunch_nutrients.dart';
import 'package:calorie_counter/data/local/entity/snack_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [TotalNutrientsPerDay, 
                                BreakfastNutrients,
                                LunchNutrients,
                                DinnerNutrients,
                                SnackNutrients,
                                Food])
abstract class AppDatabase extends FloorDatabase {

  TotalNutrientsPerDayDao get totalNutrientsPerDayDao;
  BreakfastNutrientsDao get breakfastNutrientsDao;
  LunchNutrientsDao get lunchNutrientsDao;
  DinnerNutrientsDao get dinnerNutrientsDao;
  SnackNutrientsDao get snackNutrientsDao;
  FoodDao get foodDao;

  static Future<AppDatabase> getInstance() async {
    return await $FloorAppDatabase.databaseBuilder('app_db.sqlite').build();
  }

}