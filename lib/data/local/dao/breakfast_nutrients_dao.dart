
import 'package:calorie_counter/data/local/entity/breakfast_nutrients.dart';
import 'package:floor/floor.dart';

@dao
abstract class BreakfastNutrientsDao {

  @Query('SELECT * FROM breakfast_nutrients WHERE id = :id')
  Future<BreakfastNutrients> findBreakfastById(int id);

  @Query('SELECT * FROM breakfast_nutrients WHERE total_nutrients_per_day_id = :id')
  Future<BreakfastNutrients> findBreakfastByTotalNutrientsId(int id);

  @Query('SELECT * FROM breakfast_nutrients')
  Future<List<BreakfastNutrients>> getAllBreakfast();

  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<int> insertBreakfast(BreakfastNutrients breakfastNutrients);

  @Update(onConflict: OnConflictStrategy.IGNORE)
  Future<int> updateBreakfast(BreakfastNutrients breakfastNutrients);

  @delete
  Future<int> deleteBreakfast(BreakfastNutrients breakfastNutrients);

}