import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:calorie_counter/util/constant/meal_type.dart';
import 'package:calorie_counter/util/extension/ext_date_time_formatter.dart';
import 'package:calorie_counter/util/extension/ext_meal_nutrients_list.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'daily_summary_event.dart';

part 'daily_summary_state.dart';

class DailySummaryBloc extends Bloc<DailySummaryEvent, DailySummaryState> {
  DailySummaryBloc(
      this._totalNutrientsPerDayRepository, this._mealNutrientsRepository)
      : super(InitialDailySummaryState());

  final TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;
  final MealNutrientsRepository _mealNutrientsRepository;

  @override
  Stream<DailySummaryState> mapEventToState(DailySummaryEvent event) async* {
    if (event is ChangeTimeEvent) {
      var currentDateTime = event.dateTime;
      var dateTimeString = _changeTimeFormatString(currentDateTime);
      yield LoadedDateTimeState(dateTimeString, currentDateTime);
    } else if (event is LoadTotalNutrientsEvent) {
      final date = event.dateTime.formatDate('EEEE, MMM d, yyyy');
      var totalNutrients = await _getTotalNutrientsPerDay(date);
      var listOfMealNutrients =
          await _getListOfMealNutrients(date, totalNutrients);
      yield LoadedDailySummaryState(totalNutrients, listOfMealNutrients);
    }
  }

  String _changeTimeFormatString(DateTime dateTime) {
    final currentDate = DateTime.now().formatDate('MM-dd-yyyy');
    final selectedDate = dateTime.formatDate('MM-dd-yyyy');

    if (currentDate == selectedDate) {
      return 'Today';
    } else {
      return selectedDate;
    }
  }

  Future<TotalNutrientsPerDay> _getTotalNutrientsPerDay(String date) async {
    final totalNutrientsPerDay =
        await _totalNutrientsPerDayRepository.getTotalNutrientsByDate(date);
    if (totalNutrientsPerDay == null) {
      final id = await _totalNutrientsPerDayRepository.getRowCount();
      final currentId = id + 1;

      return TotalNutrientsPerDay(currentId, date, 0, 0, 0, 0);
    }
    return totalNutrientsPerDay;
  }

  Future<List<MealNutrients>> _getListOfMealNutrients(
      String date, TotalNutrientsPerDay totalNutrientsPerDay) async {
    var listOfMealNutrients =
        await _mealNutrientsRepository.findAllDataWith(totalNutrientsPerDay.id);

    if (listOfMealNutrients == null) {
      List<MealNutrients> listOfMealNutrients = [];

      listOfMealNutrients.add(_createDefaultMealNutrients(
          totalNutrientsPerDay.id, MealType.BREAKFAST, date));
      listOfMealNutrients.add(_createDefaultMealNutrients(
          totalNutrientsPerDay.id, MealType.LUNCH, date));
      listOfMealNutrients.add(_createDefaultMealNutrients(
          totalNutrientsPerDay.id, MealType.DINNER, date));
      listOfMealNutrients.add(_createDefaultMealNutrients(
          totalNutrientsPerDay.id, MealType.SNACK, date));

      return listOfMealNutrients;
    } else {
      if (!listOfMealNutrients.containsType(MealType.BREAKFAST)) {
        listOfMealNutrients.add(_createDefaultMealNutrients(
            totalNutrientsPerDay.id, MealType.BREAKFAST, date));
      }

      if (!listOfMealNutrients.containsType(MealType.LUNCH)) {
        listOfMealNutrients.add(_createDefaultMealNutrients(
            totalNutrientsPerDay.id, MealType.LUNCH, date));
      }

      if (!listOfMealNutrients.containsType(MealType.DINNER)) {
        listOfMealNutrients.add(_createDefaultMealNutrients(
            totalNutrientsPerDay.id, MealType.DINNER, date));
      }

      if (!listOfMealNutrients.containsType(MealType.SNACK)) {
        listOfMealNutrients.add(_createDefaultMealNutrients(
            totalNutrientsPerDay.id, MealType.SNACK, date));
      }

      for (var mealNutrients in listOfMealNutrients) {
        mealNutrients.date = date;
      }

      listOfMealNutrients.sort((a, b) => a.type.compareTo(b.type));
      return listOfMealNutrients;
    }
  }

  MealNutrients _createDefaultMealNutrients(
      int totalNutrientsPerDayId, int type, String date) {
    return MealNutrients(0, 0, 0, 0, 0, type, totalNutrientsPerDayId,
        date: date);
  }
}
