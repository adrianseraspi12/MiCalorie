import 'package:floor/floor.dart';
import 'package:calorie_counter/data/local/entity/breakfast_nutrients.dart';
import 'package:calorie_counter/data/local/entity/dinner_nutrients.dart';
import 'package:calorie_counter/data/local/entity/lunch_nutrients.dart';
import 'package:calorie_counter/data/local/entity/snack_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/model/food.dart';

@Database(version: 1, entities: [TotalNutrientsPerDay, 
                                BreakfastNutrients,
                                LunchNutrients,
                                DinnerNutrients,
                                SnackNutrients,
                                Food])
abstract class AppDatabase extends FloorDatabase {


}