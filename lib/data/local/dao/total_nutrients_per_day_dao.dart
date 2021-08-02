
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:floor/floor.dart';

@dao
abstract class TotalNutrientsPerDayDao {

  @Query('SELECT * FROM total_nutrients_per_day WHERE date = :date')
  Future<TotalNutrientsPerDay> findTotalNutrientsByDate(String date);

  @Query('SELECT * FROM total_nutrients_per_day WHERE id = :id')
  Future<TotalNutrientsPerDay> findTotalNutrientsById(int id);

  @Query('SELECT * FROM total_nutrients_per_day')
  Future<List<TotalNutrientsPerDay>> getAllNutrients();

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> insertTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay);

  @Update(onConflict: OnConflictStrategy.ignore)
  Future<int> updateTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay);

  @delete
  Future<int> deleteTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay);

}