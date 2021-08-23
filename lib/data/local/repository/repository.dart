import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';

typedef SuccessCallback<T> = Function(T);
typedef FailCallback = Function(String);

abstract class Repository<T> {
  Future<List<T>?> findAllDataWith(int id);

  Future<bool> futureUpsert(T data);

  Future<T?> getDataById(int id);

  Future<int> getRowCount();

  void upsert(T data);

  void remove(T data);
}

abstract class TotalNutrientsRepository
    extends Repository<TotalNutrientsPerDay> {
  Future<TotalNutrientsPerDay?> getTotalNutrientsByDate(String itemId);
}
