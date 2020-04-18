import 'package:floor/floor.dart';

import 'dinner_nutrients.dart';
import 'lunch_nutrients.dart';
import 'snack_nutrients.dart';
import 'breakfast_nutrients.dart';

@Entity(tableName: 'total_nutrients_per_day',
        foreignKeys: [
          ForeignKey(childColumns: ['breakfast_id'],
                    parentColumns: ['id'], 
                    entity: BreakfastNutrients),

          ForeignKey(childColumns: ['lunch_id'],
                    parentColumns: ['id'], 
                    entity: LunchNutrients),

          ForeignKey(childColumns: ['dinner_id'],
                    parentColumns: ['id'], 
                    entity: DinnerNutrients),

          ForeignKey(childColumns: ['snack_id'],
                    parentColumns: ['id'], 
                    entity: SnackNutrients),
          
        ])
class TotalNutrientsPerDay {

  @primaryKey
  final int id;
  final int date;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;

  @ColumnInfo(name: 'breakfast_id')
  final int breakfastId;

  @ColumnInfo(name: 'lunch_id')
  final int lunchId;

  @ColumnInfo(name: 'dinner_id')
  final int dinnerId;

  @ColumnInfo(name: 'snack_id')
  final int snackId;

  TotalNutrientsPerDay(this.id,
                      this.breakfastId,
                      this.lunchId,
                      this.dinnerId,
                      this.snackId,
                      this.date, 
                      this.calories,
                      this.carbs,
                      this.fat,
                      this.protein);
}