import 'dart:async';
import 'package:calorie_counter/data/model/meal_summary.dart';

import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:rxdart/subjects.dart';
import 'bloc.dart';

class DailySummaryBloc implements Bloc {
  
  final _dailySummaryController = PublishSubject<DailySummaryResult>();
  Stream<DailySummaryResult> get dailySummaryResultStream => _dailySummaryController.stream;

  TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;

  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _totalNutrientsPerDayRepository = TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
    changeTotalNutrients("03/20/2020");
  }

  void changeTotalNutrients(String dateInMills) async {
    List<MealSummary> listMealSummary = [];
    // final totalNutrientsPerDay = await _totalNutrientsPerDayRepository.get<String>(dateInMills);
    final totalNutrientsPerDay = TotalNutrientsPerDay(0, 0, 0, 0, 0, '03/12/2020', 0, 0, 0, 0);
    listMealSummary.add(MealSummary(0, 'Breakfast', 0, 0, 0, 0));
    listMealSummary.add(MealSummary(0, 'Lunch', 0, 0, 0, 0));
    listMealSummary.add(MealSummary(0, 'Dinner', 0, 0, 0, 0));
    listMealSummary.add(MealSummary(0, 'Snack', 0, 0, 0, 0));

    final dailySummary = DailySummaryResult(totalNutrientsPerDay, listMealSummary);
    _dailySummaryController.sink.add(dailySummary);
  }

  @override
  void dispose() {
    _dailySummaryController.close();
  }

}

class DailySummaryResult {

  TotalNutrientsPerDay totalNutrientsPerDay;
  List<MealSummary> mealSummary;

  DailySummaryResult(this.totalNutrientsPerDay, this.mealSummary);

}