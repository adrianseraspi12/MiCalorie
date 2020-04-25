import 'package:floor/floor.dart';

@Entity(tableName: 'breakfast_nutrients')
class BreakfastNutrients {

  @primaryKey
  final int id;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;
  @ColumnInfo(name: 'total_nutrients_per_day_id')
  final int totalNutrientsPerDayId;

  BreakfastNutrients(this.id, this.calories, this.carbs, this.fat, this.protein, this.totalNutrientsPerDayId);

}