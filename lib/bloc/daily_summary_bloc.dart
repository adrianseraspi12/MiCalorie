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

  void setupRepository(String date) async {
    final database = await AppDatabase.getInstance();
    _totalNutrientsPerDayRepository = TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
    changeTotalNutrients(date);
  }

  void changeTotalNutrients(String date) async {
    List<MealSummary> listMealSummary = [];
    final totalNutrientsPerDay = await _totalNutrientsPerDayRepository.getTotalNutrientsByDate(date);

    if (totalNutrientsPerDay == null) {
      final id = await _totalNutrientsPerDayRepository.getRowCount();
      final currentId = id + 1;
      var currentTotalNutrientsPerDay = TotalNutrientsPerDay(currentId, date, 0, 0, 0, 0);
      listMealSummary.add(MealSummary(0, 'Breakfast', 0, 0, 0, 0, date, currentTotalNutrientsPerDay.id));
      listMealSummary.add(MealSummary(0, 'Lunch', 0, 0, 0, 0, date, currentTotalNutrientsPerDay.id));
      listMealSummary.add(MealSummary(0, 'Dinner', 0, 0, 0, 0, date, currentTotalNutrientsPerDay.id));
      listMealSummary.add(MealSummary(0, 'Snack', 0, 0, 0, 0, date, currentTotalNutrientsPerDay.id));

      final dailySummary = DailySummaryResult(currentTotalNutrientsPerDay, listMealSummary);
      _dailySummaryController.sink.add(dailySummary);
    }
    else {
      //  Request for meal nutrients
      listMealSummary.add(MealSummary(0, 'Breakfast', 0, 0, 0, 0, date, totalNutrientsPerDay.id));
      listMealSummary.add(MealSummary(0, 'Lunch', 0, 0, 0, 0, date, totalNutrientsPerDay.id));
      listMealSummary.add(MealSummary(0, 'Dinner', 0, 0, 0, 0, date, totalNutrientsPerDay.id));
      listMealSummary.add(MealSummary(0, 'Snack', 0, 0, 0, 0, date, totalNutrientsPerDay.id));
      
      final dailySummary = DailySummaryResult(totalNutrientsPerDay, listMealSummary);
      _dailySummaryController.sink.add(dailySummary);
    }
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