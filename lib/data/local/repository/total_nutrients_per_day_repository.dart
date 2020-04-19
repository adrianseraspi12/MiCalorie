import 'package:calorie_counter/data/local/dao/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/repository.dart';

class TotalNutrientsPerDayRepository implements Repository<TotalNutrientsPerDay> {

  final TotalNutrientsPerDayDao _totalNutrientsPerDayDao;

  TotalNutrientsPerDayRepository(this._totalNutrientsPerDayDao);

  @override
  void get(int itemDate, Listener<TotalNutrientsPerDay> listener) async {
    final totalNutrientsPerDay = await _totalNutrientsPerDayDao.findTotalNutrientsByDate(itemDate);
    
    if (totalNutrientsPerDay != null) {
      listener.onSuccess(totalNutrientsPerDay);
    }
    else {
      listener.onFailed('Cannot find the reference $itemDate');
    }
  }

  @override
  void getListOfData(Listener<List<TotalNutrientsPerDay>> listener) async {

  }

  @override
  void save(TotalNutrientsPerDay data, Listener<TotalNutrientsPerDay> listener) async {
    final itemId = await _totalNutrientsPerDayDao.insertTotalNutrients(data);
    
    if (itemId == data.id) {
      listener.onSuccess(data);
    }
    else {
      listener.onFailed('Failed saving the total nutrients');
    }

  }

  @override
  void update(TotalNutrientsPerDay data, Listener<TotalNutrientsPerDay> listener) async {
    final itemId = await _totalNutrientsPerDayDao.updateTotalNutrients(data);
    
    if (itemId == data.id) {
      listener.onSuccess(data);
    }
    else {
      listener.onFailed('Failed updating the total nutrients');
    }
  }

  @override
  void remove(TotalNutrientsPerDay data, Listener<TotalNutrientsPerDay> listener) {

  }

}