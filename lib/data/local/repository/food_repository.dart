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
  Future<Food> getDataById(int id) {
    return _foodDao.findFoodById(id);
  }

  @override
  Future<List<Food>> findAllDataWith(int id) {
    return _foodDao.findAllFoodByMealId(id);
  }

  @override
  void remove(Food data) {
    _foodDao.deleteFood(data);
  }

  @override
  Future<void> upsert(Food data) async {
    final id = await _foodDao.insertFood(data);

    if (id == -1 || id == null) {
      await _foodDao.updateFood(data);
    }
  }

  @override
  Future<bool> futureUpsert(Food data) async {
    final id = await _foodDao.insertFood(data);

    if (id == -1 || id == null) {
      var id = await _foodDao.updateFood(data);

      if (id == -1 || id == null) {
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  @override
  Future<int> getRowCount() async {
    var listOfFood = await _foodDao.getAllFood();
    return listOfFood.length;
  }
}
