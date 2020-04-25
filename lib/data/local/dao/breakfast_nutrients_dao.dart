
import 'package:calorie_counter/data/local/entity/breakfast_nutrients.dart';
import 'package:floor/floor.dart';

@dao
abstract class BreakfastNutrientsDao {

  @Query('SELECT * FROM breakfast_nutrients WHERE id = :id')
  Future<BreakfastNutrients> findBreakfastById(int id);

  @Query('SELECT * FROM breakfast_nutrients')
  Future<List<BreakfastNutrients>> getAllBreakfast();

  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<int> insertBreakfast(BreakfastNutrients breakfastNutrients);

  @Update(onConflict: OnConflictStrategy.IGNORE)
  Future<int> updateBreakfast(BreakfastNutrients breakfastNutrients);

  @delete
  Future<int> deleteBreakfast(BreakfastNutrients breakfastNutrients);

  void upsert(BreakfastNutrients breakfastNutrients) async {
    final id = await insertBreakfast(breakfastNutrients);
  
    if (id == -1) {
      await updateBreakfast(breakfastNutrients);
    }
  }

}