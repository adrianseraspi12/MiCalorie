import 'dart:async';
import 'package:calorie_counter/data/local/dao/meal_nutrients_dao.dart';
import 'package:calorie_counter/data/local/dao/total_nutrients_per_day_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

import 'package:floor/floor.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';

import 'dao/food_dao.dart';
import 'entity/meal_nutrients.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [TotalNutrientsPerDay, 
                                MealNutrients,
                                Food])
abstract class AppDatabase extends FloorDatabase {

  TotalNutrientsPerDayDao get totalNutrientsPerDayDao;
  MealNutrientsDao get mealNutrientsDao;
  FoodDao get foodDao;

  static Future<AppDatabase> getInstance() async {
    return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

}