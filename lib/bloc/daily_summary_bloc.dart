import 'dart:async';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/repository/breakfast_repository.dart';
import 'package:calorie_counter/data/local/repository/lunch_repository.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';

import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:calorie_counter/util/constant/meal_type.dart';
import 'package:rxdart/subjects.dart';
import 'package:calorie_counter/util/extension/ext_date_time_formatter.dart';
import 'package:calorie_counter/util/extension/ext_meal_nutrients_list.dart';

import 'bloc.dart';

class DailySummaryBloc implements Bloc {
  
  final _dailySummaryController = PublishSubject<DailySummaryResult>();
  Stream<DailySummaryResult> get dailySummaryResultStream => _dailySummaryController.stream;

  final _dateTimeController = PublishSubject<String>();
  Stream<String> get dateTimeStream => _dateTimeController.stream;

  TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;
  BreakfastRepository _breakfastRepository;
  LunchRepository _lunchRepository;
  MealNutrientsRepository _mealNutrientsRepository;

  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _totalNutrientsPerDayRepository = TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
    _breakfastRepository = BreakfastRepository(database.breakfastNutrientsDao);
    _lunchRepository = LunchRepository(database.lunchNutrientsDao);
    _mealNutrientsRepository = MealNutrientsRepository(database.mealNutrientsDao);

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
    List<MealNutrients> listOfMealNutrients = [];
    final totalNutrientsPerDay = await _totalNutrientsPerDayRepository.getTotalNutrientsByDate(date);

    if (totalNutrientsPerDay == null) {
      final id = await _totalNutrientsPerDayRepository.getRowCount();
      final currentId = id + 1;

      var currentTotalNutrientsPerDay = TotalNutrientsPerDay(currentId, date, 0, 0, 0, 0);
      listOfMealNutrients.add(_createDefaultMealNutrients(currentTotalNutrientsPerDay.id, MealType.BREAKFAST, date));
      listOfMealNutrients.add(_createDefaultMealNutrients(currentTotalNutrientsPerDay.id, MealType.LUNCH, date));
      listOfMealNutrients.add(_createDefaultMealNutrients(currentTotalNutrientsPerDay.id, MealType.DINNER, date));
      listOfMealNutrients.add(_createDefaultMealNutrients(currentTotalNutrientsPerDay.id, MealType.SNACK, date));

      final dailySummary = DailySummaryResult(currentTotalNutrientsPerDay, listOfMealNutrients);
      _dailySummaryController.sink.add(dailySummary);
    }
    else {
      //  Request for meal nutrients
      var listOfMealNutrients = await _mealNutrientsRepository.findAllDataWith(totalNutrientsPerDay.id);

      if (!listOfMealNutrients.containsType(MealType.BREAKFAST)) {
        listOfMealNutrients.add(_createDefaultMealNutrients(totalNutrientsPerDay.id, MealType.BREAKFAST, date));  
      }
      
      if (!listOfMealNutrients.containsType(MealType.LUNCH)) {
        listOfMealNutrients.add(_createDefaultMealNutrients(totalNutrientsPerDay.id, MealType.LUNCH, date));  
      }
      
      if (!listOfMealNutrients.containsType(MealType.DINNER)) {
        listOfMealNutrients.add(_createDefaultMealNutrients(totalNutrientsPerDay.id, MealType.DINNER, date));  
      }
    
     if (!listOfMealNutrients.containsType(MealType.SNACK)) {
        listOfMealNutrients.add(_createDefaultMealNutrients(totalNutrientsPerDay.id, MealType.SNACK, date));  
      }

      for (var mealNutrients in listOfMealNutrients) {
        mealNutrients.date = date;
      }

      listOfMealNutrients.sort((a, b) => a.type.compareTo(b.type));

      final dailySummary = DailySummaryResult(totalNutrientsPerDay, listOfMealNutrients);
      _dailySummaryController.sink.add(dailySummary);
    }
  }

  MealNutrients _createDefaultMealNutrients(int totalNutrientsPerDayId, int type, String date) {
    return MealNutrients(0, 0, 0, 0, 0, type, totalNutrientsPerDayId, date: date);
  }

  @override
  void dispose() {
    _dailySummaryController.close();
    _dateTimeController.close();
  }

}

class DailySummaryResult {

  TotalNutrientsPerDay totalNutrientsPerDay;
  List<MealNutrients> mealNutrients;

  DailySummaryResult(this.totalNutrientsPerDay, this.mealNutrients);

}