import 'package:calorie_counter/data/local/dao/breakfast_nutrients_dao.dart';
import 'package:calorie_counter/data/local/entity/breakfast_nutrients.dart';
import 'package:calorie_counter/data/local/repository/repository.dart';

class BreakfastRepository implements Repository<BreakfastNutrients> {

  final BreakfastNutrientsDao _breakfastNutrientsDao;

  BreakfastRepository(this._breakfastNutrientsDao);

  Future<BreakfastNutrients> getBreakfast(int id) {
    return _breakfastNutrientsDao.findBreakfastById(id);
  }

  Future<BreakfastNutrients> findBreakfastByTotalNutrientsId(int id) {
    return _breakfastNutrientsDao.findBreakfastByTotalNutrientsId(id);
  }

  Future<int> getTotalBreakfastCount() async {
    final listOfBreakfast = await _breakfastNutrientsDao.getAllBreakfast();
    return listOfBreakfast.length;
  }

  @override
  Future<List<BreakfastNutrients>> findAllDataWith(int id) {
    // TODO: implement findAllDataWith
    return null;
  }

  @override
  void remove(BreakfastNutrients data) {
    _breakfastNutrientsDao.deleteBreakfast(data);
  }

  @override
  void upsert(BreakfastNutrients data) {
    _breakfastNutrientsDao.upsert(data);
  }

}