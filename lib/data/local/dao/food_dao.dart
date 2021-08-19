import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:floor/floor.dart';

@dao
abstract class FoodDao {

  @Query('SELECT * FROM food WHERE meal_id = :mealId')
  Future<List<Food>?> findAllFoodByMealId(int mealId);

  @Query('SELECT * FROM food')
  Future<List<Food>> getAllFood();

  @Query('SELECT * FROM food WHERE id = :id')
  Future<Food?> findFoodById(int id);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> insertFood(Food food);

  @Update(onConflict: OnConflictStrategy.ignore)
  Future<int> updateFood(Food food);

  @delete
  Future<int> deleteFood(Food food);

}