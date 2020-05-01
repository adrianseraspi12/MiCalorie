import 'package:floor/floor.dart';

@Entity(tableName: 'food')
class Food {

  @primaryKey
  final int id;
  
  @ColumnInfo(name: 'meal_id')
  final int mealId;

  final String name;

  @ColumnInfo(name: 'number_of_servings')
  final int numOfServings;

  @ColumnInfo(name: 'serving_size')
  final String servingSize;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;

  Food(this.id, 
      this.mealId, 
      this.name, 
      this.numOfServings, 
      this.servingSize, 
      this.calories, 
      this.carbs,
      this.fat, 
      this.protein);

}