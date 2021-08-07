import 'package:calorie_counter/data/local/dao/total_nutrients_per_day_dao.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/repository.dart';

class TotalNutrientsPerDayRepository implements TotalNutrientsRepository {
  final TotalNutrientsPerDayDao _totalNutrientsPerDayDao;

  TotalNutrientsPerDayRepository(this._totalNutrientsPerDayDao);

  @override
  Future<int> getRowCount() async {
    final listOfTotalNutrients =
        await _totalNutrientsPerDayDao.getAllNutrients();
    return listOfTotalNutrients.length;
  }

  @override
  Future<TotalNutrientsPerDay?> getDataById(int id) {
    return _totalNutrientsPerDayDao.findTotalNutrientsById(id);
  }

  @override
  Future<TotalNutrientsPerDay?> getTotalNutrientsByDate(String itemId) {
    return _totalNutrientsPerDayDao.findTotalNutrientsByDate(itemId.toString());
  }

  @override
  void remove(TotalNutrientsPerDay data) async {
    await _totalNutrientsPerDayDao.deleteTotalNutrients(data);
  }

  @override
  Future<int> upsert(TotalNutrientsPerDay data) async {
    final id = await _totalNutrientsPerDayDao.insertTotalNutrients(data);

    if (id == -1) {
      return _totalNutrientsPerDayDao.updateTotalNutrients(data);
    }

    return id;
  }

  @override
  Future<bool> futureUpsert(TotalNutrientsPerDay data) async {
    final id = await _totalNutrientsPerDayDao.insertTotalNutrients(data);

    if (id == -1) {
      var id = await _totalNutrientsPerDayDao.updateTotalNutrients(data);

      if (id == -1) {
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  @override
  Future<List<TotalNutrientsPerDay>?> findAllDataWith(int id) {
    // TODO: implement findAllDataWith
    throw UnimplementedError();
  }
}
