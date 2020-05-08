import 'package:calorie_counter/data/local/dao/food_dao.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/repository/repository.dart';

class FoodRepository implements Repository<Food> {

  final FoodDao _foodDao;

  FoodRepository(this._foodDao);

  Future<int> getAllFoodCount() async {
    final listOfFood = await _foodDao.getAllFood();
    return listOfFood.length;
  }

  @override
  Future<List<Food>> findAllDataWith(int id) {
    return _foodDao.findAllFoodByMealId(id);
  }

  Future<Food> getFoodById(int id) {
    return _foodDao.findFoodById(id);
  }

  @override
  void remove(Food data) {
    _foodDao.deleteFood(data);
  }

  @override
  void upsert(Food data) async {
    final id = await _foodDao.insertFood(data);

    if (id == -1) {
      await _foodDao.updateFood(data);
    }
  }
  
}