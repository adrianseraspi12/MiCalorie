import 'package:floor/floor.dart';
import 'package:calorie_counter/data/local/entity/dinner_nutrients.dart';

@dao
abstract class DinnerNutrientsDao {

  @Query('SELECT * FROM dinner_nutrients WHERE id = :id')
  Future<DinnerNutrients> findDinnerById(int id);

  @Query('SELECT * FROM dinner_nutrients WHERE total_nutrients_per_day_id = :id')
  Future<DinnerNutrients> findDinnerByTotalNutrientsId(int id);

  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<int> insertDinner(DinnerNutrients dinnerNutrients);

  @Update(onConflict: OnConflictStrategy.IGNORE)
  Future<int> updateDinner(DinnerNutrients dinnerNutrients);

  @delete
  Future<int> deleteDinner(DinnerNutrients dinnerNutrients);

  void upsert(DinnerNutrients dinnerNutrients) async {
    final id = await insertDinner(dinnerNutrients);
  
    if (id == -1) {
      await updateDinner(dinnerNutrients);
    }
  }

}