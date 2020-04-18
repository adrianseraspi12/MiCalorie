import 'package:floor/floor.dart';

@Entity(tableName: 'breakfast_nutrients')
class BreakfastNutrients {

  @PrimaryKey(autoGenerate: true)
  final int id;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;

  BreakfastNutrients(this.id, this.calories, this.carbs, this.fat, this.protein);

}