import 'package:floor/floor.dart';
import 'package:calorie_counter/data/local/entity/lunch_nutrients.dart';

@dao
abstract class LunchNutrientsDao {

  @insert
  Future<int> insertBreakfast(LunchNutrients lunchNutrients);

  @update
  Future<int> updateBreakfast(LunchNutrients lunchNutrients);

  @delete
  Future<int> deleteBreakfast(LunchNutrients lunchNutrients);

}