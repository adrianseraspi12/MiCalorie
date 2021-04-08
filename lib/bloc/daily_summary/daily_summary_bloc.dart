import 'package:calorie_counter/data/local/data_source/i_data_source.dart';
import 'package:calorie_counter/data/local/data_source/result.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/util/extension/ext_date_time_formatter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'daily_summary_event.dart';

part 'daily_summary_state.dart';

class DailySummaryBloc extends Bloc<DailySummaryEvent, DailySummaryState> {
  DailySummaryBloc(this._dataSource) : super(InitialDailySummaryState());

  final DataSource _dataSource;

  @override
  Stream<DailySummaryState> mapEventToState(DailySummaryEvent event) async* {
    if (event is ChangeTimeEvent) {
      var currentDateTime = event.dateTime;
      var dateTimeString = _changeTimeFormatString(currentDateTime);
      yield LoadedDateTimeState(dateTimeString, currentDateTime);
    } else if (event is LoadTotalNutrientsEvent) {
      final date = event.dateTime.formatDate('EEEE, MMM d, yyyy');
      var totalNutrientsResult = await _dataSource.getTotalNutrientsPerDay(date);

      if (totalNutrientsResult is Fail) {
        return;
      }

      var totalNutrients = (totalNutrientsResult as Success<TotalNutrientsPerDay>).data;
      var mealNutrientsResult = await _dataSource.getAllMealNutrients(totalNutrients.id, date);

      if (mealNutrientsResult is Fail) {
        return;
      }

      var listOfMeal = (mealNutrientsResult as Success<List<MealNutrients>>).data;
      yield LoadedDailySummaryState(totalNutrients, listOfMeal);
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
}
