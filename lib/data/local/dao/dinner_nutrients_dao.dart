import 'package:floor/floor.dart';
import 'package:calorie_counter/data/local/entity/dinner_nutrients.dart';

@dao
abstract class DinnerNutrientsDao {

  @insert
  Future<int> insertBreakfast(DinnerNutrients dinnerNutrients);

  @update
  Future<int> updateBreakfast(DinnerNutrients dinnerNutrients);

  @delete
  Future<int> deleteBreakfast(DinnerNutrients dinnerNutrients);

}