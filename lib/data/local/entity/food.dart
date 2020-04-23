import 'package:calorie_counter/data/local/entity/breakfast_nutrients.dart';
import 'package:calorie_counter/data/local/entity/dinner_nutrients.dart';
import 'package:calorie_counter/data/local/entity/lunch_nutrients.dart';
import 'package:calorie_counter/data/local/entity/snack_nutrients.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'food', 
        foreignKeys: [

          ForeignKey(childColumns: ['meal_id'], 
                    parentColumns: ['id'],
                    entity: BreakfastNutrients),
          ForeignKey(childColumns: ['meal_id'], 
                    parentColumns: ['id'],
                    entity: LunchNutrients),
            
          ForeignKey(childColumns: ['meal_id'], 
                    parentColumns: ['id'],
                    entity: DinnerNutrients),

          ForeignKey(childColumns: ['meal_id'], 
                    parentColumns: ['id'],
                    entity: SnackNutrients),

        ])
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