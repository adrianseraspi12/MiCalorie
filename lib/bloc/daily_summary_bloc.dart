import 'dart:async';

import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/breakfast_nutrients.dart';
import 'package:calorie_counter/data/local/entity/dinner_nutrients.dart';
import 'package:calorie_counter/data/local/entity/lunch_nutrients.dart';
import 'package:calorie_counter/data/local/entity/snack_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:rxdart/subjects.dart';
import 'bloc.dart';

class DailySummaryBloc implements Bloc {
  
  final _totalNutrientsPerDayController = PublishSubject<TotalNutrientsPerDay>();
  final _breakfastController = PublishSubject<BreakfastNutrients>();
  final _lunchController = PublishSubject<LunchNutrients>();
  final _dinnerController = PublishSubject<DinnerNutrients>();
  final _snackController = PublishSubject<SnackNutrients>();

  Stream<TotalNutrientsPerDay> get totalNutrientsPerDayStream => _totalNutrientsPerDayController.stream;
  Stream<BreakfastNutrients> get breakfastNutrientsStream => _breakfastController.stream;
  Stream<LunchNutrients> get lunchNutrientsStream => _lunchController.stream;
  Stream<DinnerNutrients> get dinnerNutrientsStream => _dinnerController.stream;
  Stream<SnackNutrients> get snackNutrientsStream => _snackController.stream;

  TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;

  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _totalNutrientsPerDayRepository = TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
    changeTotalNutrients("03/20/2020");
  }

  void changeTotalNutrients(String dateInMills) async {
    _totalNutrientsPerDayRepository.get<String>(dateInMills, 
    (data) {
      _totalNutrientsPerDayController.sink.add(data);
    }, 
    (message) {
      print('ERROR = $message');
    });
  }

  @override
  void dispose() {
    _totalNutrientsPerDayController.close();
    _breakfastController.close();
    _lunchController.close();
    _dinnerController.close();
    _snackController.close();
  }

}