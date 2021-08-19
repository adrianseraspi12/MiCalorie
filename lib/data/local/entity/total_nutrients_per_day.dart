import 'package:floor/floor.dart';

@Entity(tableName: 'total_nutrients_per_day')
class TotalNutrientsPerDay {

  @primaryKey
  final int? id;
  final String? date;
  final int? calories;
  final int? carbs;
  final int? fat;
  final int? protein;

  TotalNutrientsPerDay(this.id,
                      this.date, 
                      this.calories,
                      this.carbs,
                      this.fat,
                      this.protein);
}