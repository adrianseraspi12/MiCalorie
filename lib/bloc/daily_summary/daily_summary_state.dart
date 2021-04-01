part of 'daily_summary_bloc.dart';

@immutable
abstract class DailySummaryState extends Equatable {

  @override
  List<Object> get props => [];

}

class InitialDailySummaryState extends DailySummaryState {}

class LoadingDailySummaryState extends DailySummaryState {}

class LoadedDateTimeState extends DailySummaryState {

  final String dateTimeString;
  final DateTime dateTime;

  LoadedDateTimeState(this.dateTimeString, this.dateTime);

  @override
  List<Object> get props => [dateTimeString, dateTime];

}

class LoadedDailySummaryState extends DailySummaryState {

  final TotalNutrientsPerDay totalNutrientsPerDay;
  final List<MealNutrients> mealNutrients;

  LoadedDailySummaryState(this.totalNutrientsPerDay, this.mealNutrients);

  @override
  List<Object> get props => [totalNutrientsPerDay, mealNutrients];

}

