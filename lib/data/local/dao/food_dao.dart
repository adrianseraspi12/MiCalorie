import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:floor/floor.dart';

@dao
abstract class FoodDao {

  @Query('SELECT * FROM food WHERE mealId = :mealId')
  Future<List<Food>> findAllFoodByMealId(int mealId);

  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<int> insertFood(Food food);

  @Update(onConflict: OnConflictStrategy.IGNORE)
  Future<int> updateFood(Food food);

  @delete
  Future<int> deleteFood(Food food);

  void upsert(Food food) async {
    final id = await insertFood(food);
  
    if (id == -1) {
      await updateFood(food);
    }
  }

}