
import 'package:floor/floor.dart';

@entity
class TotalNutrientsPerDay {

  @primaryKey
  final int id;
  final int date;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;

  TotalNutrientsPerDay(this.id, this.date, this.calories, this.carbs, this.fat, this.protein);
}