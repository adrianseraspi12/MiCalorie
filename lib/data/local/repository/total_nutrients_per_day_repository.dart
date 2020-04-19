import 'package:calorie_counter/data/local/dao/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/repository.dart';

class TotalNutrientsPerDayRepository implements Repository<TotalNutrientsPerDay> {

  final TotalNutrientsPerDayDao _totalNutrientsPerDayDao;

  TotalNutrientsPerDayRepository(this._totalNutrientsPerDayDao);

  @override
  void get<String>(String date, successCallback, failCallback) async {
    final totalNutrientsPerDay = await _totalNutrientsPerDayDao.findTotalNutrientsByDate(date.toString());

    if (totalNutrientsPerDay != null) {
      successCallback(totalNutrientsPerDay);
    }
    else {
      final totalNutrientsPerDay = TotalNutrientsPerDay(0, 0, 0, 0, 0, date.toString(), 0, 0, 0, 0);
      successCallback(totalNutrientsPerDay);
    }
  }

  @override
  void getListOfData(successCallback, failCallback) async {

  }

  @override
  void remove(TotalNutrientsPerDay data, successCallback, failCallback) async {
    final itemId = await _totalNutrientsPerDayDao.deleteTotalNutrients(data);
    
    if (itemId == data.id) {
      successCallback(data);
    }
    else {
      failCallback('Failed deleting the total nutrients');
    }
  }

  @override
  void update(TotalNutrientsPerDay data, successCallback, failCallback) async {
    final itemId = await _totalNutrientsPerDayDao.insertTotalNutrients(data);
    
    if (itemId == data.id) {
      successCallback(data);
    }
    else {
      failCallback('Failed updating the total nutrients');
    }   

  }

  @override
  void save(TotalNutrientsPerDay data, successCallback, failCallback) async {
    final itemId = await _totalNutrientsPerDayDao.insertTotalNutrients(data);
    
    if (itemId == data.id) {
      successCallback(data);
    }
    else {
      failCallback('Failed saving the total nutrients');
    } 
  }

}