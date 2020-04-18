import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:floor/floor.dart';

@entity
class BreakfastNutrients {

  @primaryKey
  final int id;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;

}