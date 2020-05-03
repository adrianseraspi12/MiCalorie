
import 'package:floor/floor.dart';

@Entity(tableName: 'meal_nutrients')
class MealNutrients {
  @primaryKey
  final int id;
  final int calories;
  final int carbs;
  final int fat;
  final int protein;
  final int type;

  @ColumnInfo(name: 'total_nutrients_per_day_id')
  final int totalNutrientsPerDayId;

  @ignore
  String date;

  MealNutrients(this.id, this.calories, this.carbs, this.fat, this.protein, this.type, this.totalNutrientsPerDayId, {this.date = ''});
  
}