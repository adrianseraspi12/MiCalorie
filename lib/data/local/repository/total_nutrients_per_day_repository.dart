import 'package:calorie_counter/data/local/dao/total_nutrients_per_day_dao.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/repository.dart';

class TotalNutrientsPerDayRepository implements Repository<TotalNutrientsPerDay> {

  final TotalNutrientsPerDayDao _totalNutrientsPerDayDao;

  TotalNutrientsPerDayRepository(this._totalNutrientsPerDayDao);

  Future<int> getRowCount() async {
    final listOfTotalNutrients = await _totalNutrientsPerDayDao.getAllNutrients();
    return listOfTotalNutrients.length;
  }

  Future<TotalNutrientsPerDay> getTotalNutrientsByDate(String itemId) {
    return _totalNutrientsPerDayDao.findTotalNutrientsByDate(itemId.toString());
  }

  Future<TotalNutrientsPerDay> getTotalNutrientsById(int id) {
    return _totalNutrientsPerDayDao.findTotalNutrientsById(id);
  }

  @override
  void remove(TotalNutrientsPerDay data) async {
    await _totalNutrientsPerDayDao.deleteTotalNutrients(data);
  }

  @override
  Future<List<TotalNutrientsPerDay>> findAllDataWith(int id) {
    // TODO: implement findAllDataWith
    return null;
  }

  @override
  void upsert(TotalNutrientsPerDay data) async {
    final id = await _totalNutrientsPerDayDao.insertTotalNutrients(data);
  
    if (id == -1 || id == null) {
      await _totalNutrientsPerDayDao.updateTotalNutrients(data);
    }

  }

}