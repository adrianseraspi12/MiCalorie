import 'package:calorie_counter/data/local/dao/lunch_nutrients_dao.dart';
import 'package:calorie_counter/data/local/entity/lunch_nutrients.dart';
import 'package:calorie_counter/data/local/repository/repository.dart';

class LunchRepository implements Repository<LunchNutrients> {
  
  final LunchNutrientsDao _lunchNutrientsDao;

  LunchRepository(this._lunchNutrientsDao);

  Future<LunchNutrients> getBreakfast(int id) {
    return _lunchNutrientsDao.findLunchById(id);
  }

  Future<LunchNutrients> findLunchByTotalNutrientsId(int id) {
    return _lunchNutrientsDao.findLunchByTotalNutrientsId(id);
  }

  Future<int> getTotalBreakfastCount() async {
    final listOfBreakfast = await _lunchNutrientsDao.getAllLunch();
    return listOfBreakfast.length;
  }

  @override
  Future<List<LunchNutrients>> findAllDataWith(int id) {
    // TODO: implement findAllDataWith
    return null;
  }

  @override
  void remove(LunchNutrients data) {
    _lunchNutrientsDao.deleteLunch(data);
  }

  @override
  void upsert(LunchNutrients data) async {

    final id = await _lunchNutrientsDao.insertLunch(data);
  
    if (id == -1 || id == null) {
      await _lunchNutrientsDao.updateLunch(data);
    }
  }

}