import 'package:floor/floor.dart';

@Entity(tableName: 'breakfast_nutrients')
class BreakfastNutrients {

  @primaryKey
  final int id;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;

}