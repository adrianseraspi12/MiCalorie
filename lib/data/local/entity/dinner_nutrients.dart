import 'package:floor/floor.dart';

@Entity(tableName: 'dinner_nutrients')
class DinnerNutrients {

  @primaryKey
  final int id;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;

  DinnerNutrients(this.id, this.calories, this.carbs, this.fat, this.protein);

}