import 'package:calorie_counter/data/local/repository/repository.dart';
import 'package:rxdart/subjects.dart';

import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'bloc.dart';

class DailySummaryBloc implements Bloc {
  
  final _totalNutrientsPerDayController = PublishSubject<TotalNutrientsPerDay>();
  Stream<TotalNutrientsPerDay> getTotalNutrientsPerDay => _totalNutrientsPerDayController.stream;

  TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;

  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _totalNutrientsPerDayRepository = TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
  }

  void changeTotalNutrients(int dateInMills) async {
    _totalNutrientsPerDayRepository.get(dateInMills, 
    (data) {
      _totalNutrientsPerDayController.add(data);
    }, 
    (message) {
      print('ERROR = $message');
    });
  }

  @override
  void dispose() {
    _totalNutrientsPerDayController.close();
  }

}