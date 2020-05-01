import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:floor/floor.dart';

@dao
abstract class FoodDao {

  @Query('SELECT * FROM food WHERE meal_id = :mealId')
  Future<List<Food>> findAllFoodByMealId(int mealId);

  @Query('SELECT * FROM food')
  Future<List<Food>> getAllFood();

  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<int> insertFood(Food food);

  @Update(onConflict: OnConflictStrategy.IGNORE)
  Future<int> updateFood(Food food);

  @delete
  Future<int> deleteFood(Food food);

}