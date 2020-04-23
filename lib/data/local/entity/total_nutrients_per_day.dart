import 'package:floor/floor.dart';

@Entity(tableName: 'total_nutrients_per_day')
class TotalNutrientsPerDay {

  @primaryKey
  final int id;
  final String date;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;

  TotalNutrientsPerDay(this.id,
                      this.date, 
                      this.calories,
                      this.carbs,
                      this.fat,
                      this.protein);
}