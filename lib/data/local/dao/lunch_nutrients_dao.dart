import 'package:floor/floor.dart';
import 'package:calorie_counter/data/local/entity/lunch_nutrients.dart';

@dao
abstract class LunchNutrientsDao {

  @Query('SELECT * FROM lunch_nutrients WHERE id = :id')
  Future<LunchNutrients> findLunchById(int id);

  @insert
  Future<int> insertLunch(LunchNutrients lunchNutrients);

  @update
  Future<int> updateLunch(LunchNutrients lunchNutrients);

  @delete
  Future<int> deleteLunch(LunchNutrients lunchNutrients);

}