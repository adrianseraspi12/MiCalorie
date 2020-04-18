
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:floor/floor.dart';

@dao
abstract class TotalNutrientsPerDayDao {

  @Query('SELECT * FROM total_nutrients_per_day WHERE date = :date')
  Future<TotalNutrientsPerDay> findTotalNutrientsByDate(int date);

  @insert
  Future<int> insertTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay);

  @update
  Future<int> updateTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay);

  @delete
  Future<int> deleteTotalNutrients(TotalNutrientsPerDay totalNutrientsPerDay);
  
}