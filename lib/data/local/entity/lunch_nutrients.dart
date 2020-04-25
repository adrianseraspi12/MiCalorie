
import 'package:floor/floor.dart';

@Entity(tableName: 'lunch_nutrients')
class LunchNutrients {

  @primaryKey  
  final int id;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;
  @ColumnInfo(name: 'total_nutrients_per_day_id')
  final int totalNutrientsPerDayId;

  LunchNutrients(this.id, this.calories, this.carbs, this.fat, this.protein, this.totalNutrientsPerDayId);

}