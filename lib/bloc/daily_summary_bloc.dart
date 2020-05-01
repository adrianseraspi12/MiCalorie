import 'dart:async';
import 'package:calorie_counter/data/local/repository/breakfast_repository.dart';
import 'package:calorie_counter/data/local/repository/lunch_repository.dart';
import 'package:calorie_counter/data/model/meal_summary.dart';

import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:rxdart/subjects.dart';
import 'package:calorie_counter/util/extension/ext_date_time_formatter.dart';

import 'bloc.dart';

class DailySummaryBloc implements Bloc {
  
  final _dailySummaryController = PublishSubject<DailySummaryResult>();
  Stream<DailySummaryResult> get dailySummaryResultStream => _dailySummaryController.stream;

  final _dateTimeController = PublishSubject<String>();
  Stream<String> get dateTimeStream => _dateTimeController.stream;

  TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;
  BreakfastRepository _breakfastRepository;
  LunchRepository _lunchRepository;

  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _totalNutrientsPerDayRepository = TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
    _breakfastRepository = BreakfastRepository(database.breakfastNutrientsDao);
    _lunchRepository = LunchRepository(database.lunchNutrientsDao);

    final formattedDate = DateTime.now().formatDate('MM-dd-yyyy');
    changeTotalNutrients(formattedDate);
  }

  void updateTimeAndTotalNutrients(DateTime date) {
    final currentDate = DateTime.now().formatDate('EEEE, MMM d, yyyy');
    final selectedDate = date.formatDate('EEEE, MMM d, yyyy');

    if (currentDate == selectedDate) {
      _dateTimeController.sink.add('Today');
    }
    else {
      _dateTimeController.sink.add(selectedDate);
    }
    
    final formattedDate = date.formatDate('MM-dd-yyyy');
    changeTotalNutrients(formattedDate);
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
      final breakfastNutrients = await _loadBreakfast(totalNutrientsPerDay);
      listMealSummary.add(breakfastNutrients);

      final lunchNutrients = await _loadLunch(totalNutrientsPerDay);
      listMealSummary.add(lunchNutrients);

      listMealSummary.add(MealSummary(0, 'Dinner', 0, 0, 0, 0, date, totalNutrientsPerDay.id));
      listMealSummary.add(MealSummary(0, 'Snack', 0, 0, 0, 0, date, totalNutrientsPerDay.id));
      
      final dailySummary = DailySummaryResult(totalNutrientsPerDay, listMealSummary);
      _dailySummaryController.sink.add(dailySummary);
    }
  }

  Future<MealSummary> _loadBreakfast(TotalNutrientsPerDay totalNutrientsPerDay) async {
    final breakFastNutrients = await _breakfastRepository.findBreakfastByTotalNutrientsId(totalNutrientsPerDay.id);
    
    if (breakFastNutrients != null) {
      return MealSummary(
      breakFastNutrients.id,
        'Breakfast',
        breakFastNutrients.calories, 
        breakFastNutrients.carbs, 
        breakFastNutrients.fat, 
        breakFastNutrients.protein, 
        totalNutrientsPerDay.date, 
        totalNutrientsPerDay.id);
    }
    else {
      return MealSummary(0, 'Lunch', 0, 0, 0, 0, totalNutrientsPerDay.date, totalNutrientsPerDay.id);
    }
  }

  Future<MealSummary> _loadLunch(TotalNutrientsPerDay totalNutrientsPerDay) async {
    final lunchNutrients = await _lunchRepository.findLunchByTotalNutrientsId(totalNutrientsPerDay.id);
    
    if (lunchNutrients != null) {
      return MealSummary(
        lunchNutrients.id,
        'Lunch',
        lunchNutrients.calories, 
        lunchNutrients.carbs, 
        lunchNutrients.fat, 
        lunchNutrients.protein, 
        totalNutrientsPerDay.date, 
        totalNutrientsPerDay.id);
    }
    else {
      return MealSummary(0, 'Lunch', 0, 0, 0, 0, totalNutrientsPerDay.date, totalNutrientsPerDay.id);
    }
    
  }

  @override
  void dispose() {
    _dailySummaryController.close();
    _dateTimeController.close();
  }

}

class DailySummaryResult {

  TotalNutrientsPerDay totalNutrientsPerDay;
  List<MealSummary> mealSummary;

  DailySummaryResult(this.totalNutrientsPerDay, this.mealSummary);

}