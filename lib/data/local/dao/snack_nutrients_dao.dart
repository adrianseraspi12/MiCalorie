
import 'package:calorie_counter/data/local/entity/snack_nutrients.dart';
import 'package:floor/floor.dart';

@dao
abstract class SnackNutrientsDao {

  @Query('SELECT * FROM snack_nutrients WHERE id = :id')
  Future<SnackNutrients> findSnackById(int id);

  @insert
  Future<int> insertSnack(SnackNutrients snackNutrients);

  @update
  Future<int> updateSnack(SnackNutrients snackNutrients);

  @delete
  Future<int> deleteSnack(SnackNutrients snackNutrients);

}