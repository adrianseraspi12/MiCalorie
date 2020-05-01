import 'package:floor/floor.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';

@dao
abstract class MealNutrientsDao {

  @Query('SELECT * FROM meal_nutrients WHERE id = :id')
  Future<MealNutrients> findMealById(int id);

  @Query('SELECT * FROM meal_nutrients WHERE total_nutrients_per_day_id = :id')
  Future<List<MealNutrients>> finddMealByTotalNutrientsId(int id);

  @Query('SELECT * FROM meal_nutrients')
  Future<List<MealNutrients>> getAlldMeal();

  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<int> insertMeal(MealNutrients breakfastNutrients);

  @Update(onConflict: OnConflictStrategy.IGNORE)
  Future<int> updatedMeal(MealNutrients breakfastNutrients);

  @delete
  Future<int> deletedMeal(MealNutrients breakfastNutrients);

}