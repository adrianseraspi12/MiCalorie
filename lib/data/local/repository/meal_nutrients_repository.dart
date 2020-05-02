import 'package:calorie_counter/data/local/dao/meal_nutrients_dao.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/repository/repository.dart';

class MealNutrientsRepository implements Repository<MealNutrients> {
  
  final MealNutrientsDao _mealNutrientsDao;

  MealNutrientsRepository(this._mealNutrientsDao);

  Future<MealNutrients> getMeal(int id) {
    return _mealNutrientsDao.findMealById(id);
  }

  Future<int> getAllMealCount() async {
    final allMeals = await _mealNutrientsDao.getAlldMeal();
    return allMeals.length;
  }

  @override
  Future<List<MealNutrients>> findAllDataWith(int id) {
    return _mealNutrientsDao.finddMealByTotalNutrientsId(id);
  }

  @override
  void remove(MealNutrients data) {
    _mealNutrientsDao.deletedMeal(data);
  }

  @override
  void upsert(MealNutrients data) async {
    final id = await _mealNutrientsDao.insertMeal(data);
  
    if (id == -1 || id == null) {
      await _mealNutrientsDao.updatedMeal(data);
    }
  }

}