import 'package:floor/floor.dart';
import 'package:calorie_counter/data/model/food.dart';

@dao
abstract class FoodDao {

  @Query('SELECT * FROM food WHERE mealId = :mealId')
  Future<List<Food>> findAllFoodByMealId(int mealId);

  @insert
  Future<int> insertFood(Food food);

  @update
  Future<int> updateFood(Food food);

  @delete
  Future<int> deleteFood(Food food);

}