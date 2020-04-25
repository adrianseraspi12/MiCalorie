
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:floor/floor.dart';

@dao
abstract class TotalNutrientsPerDayDao {

  @Query('SELECT * FROM total_nutrients_per_day WHERE date = :date')
  Future<TotalNutrientsPerDay> findTotalNutrientsByDate(String date);

  @Query('SELECT * FROM total_nutrients_per_day')
  Future<List<TotalNutrientsPerDay>> getAllNutrients();

  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<int> insertTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay);

  @Update(onConflict: OnConflictStrategy.IGNORE)
  Future<int> updateTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay);

  @delete
  Future<int> deleteTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay);
  
  void upsert(TotalNutrientsPerDay totalNutrientsPerDay) async {
    final id = await insertTotalNutrients(totalNutrientsPerDay);
  
    if (id == -1) {
      await updateTotalNutrients(totalNutrientsPerDay);
    }
  }

}