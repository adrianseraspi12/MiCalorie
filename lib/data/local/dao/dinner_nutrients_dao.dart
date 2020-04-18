import 'package:floor/floor.dart';
import 'package:calorie_counter/data/local/entity/dinner_nutrients.dart';

@dao
abstract class DinnerNutrientsDao {

  @Query('SELECT * FROM dinner_nutrients WHERE id = :id')
  Future<DinnerNutrients> findDinnerById(int id);

  @insert
  Future<int> insertDinner(DinnerNutrients dinnerNutrients);

  @update
  Future<int> updateDinner(DinnerNutrients dinnerNutrients);

  @delete
  Future<int> deleteDinner(DinnerNutrients dinnerNutrients);

}