import 'package:floor/floor.dart';

@Entity(tableName: 'snack_nutrients')
class SnackNutrients {

  @PrimaryKey(autoGenerate: true)
  final int id;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;

  SnackNutrients(this.id, this.calories, this.carbs, this.fat, this.protein);
  
}