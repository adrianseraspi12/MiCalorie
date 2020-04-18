
import 'package:calorie_counter/data/local/entity/breakfast_nutrients.dart';
import 'package:floor/floor.dart';

@dao
abstract class BreakfastNutrientsDao {

  @insert
  Future<int> insertBreakfast(BreakfastNutrients breakfastNutrients);

  @update
  Future<int> updateBreakfast(BreakfastNutrients breakfastNutrients);

  @delete
  Future<int> deleteBreakfast(BreakfastNutrients breakfastNutrients);

}