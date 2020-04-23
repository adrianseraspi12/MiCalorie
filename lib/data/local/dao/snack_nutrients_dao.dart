
import 'package:calorie_counter/data/local/entity/snack_nutrients.dart';
import 'package:floor/floor.dart';

@dao
abstract class SnackNutrientsDao {

  @Query('SELECT * FROM snack_nutrients WHERE id = :id')
  Future<SnackNutrients> findSnackById(int id);

  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<int> insertSnack(SnackNutrients snackNutrients);

  @Update(onConflict: OnConflictStrategy.IGNORE)
  Future<int> updateSnack(SnackNutrients snackNutrients);

  @delete
  Future<int> deleteSnack(SnackNutrients snackNutrients);

  void upsert(SnackNutrients snackNutrients) async {
    final id = await insertSnack(snackNutrients);
  
    if (id == -1) {
      await updateSnack(snackNutrients);
    }
  }

}