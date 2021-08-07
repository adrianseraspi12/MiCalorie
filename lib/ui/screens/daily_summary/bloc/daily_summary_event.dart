part of 'daily_summary_bloc.dart';

abstract class DailySummaryEvent extends Equatable {
  
  @override
  List<Object> get props => [];
  
}

class ShowDatePickerEvent extends DailySummaryEvent {}

class ChangeTimeEvent extends DailySummaryEvent {
  
  final DateTime dateTime;

  ChangeTimeEvent(this.dateTime);

  @override
  List<Object> get props => [dateTime];
  
}

class LoadTotalNutrientsEvent extends DailySummaryEvent {

  final DateTime dateTime;

  LoadTotalNutrientsEvent(this.dateTime);

  @override
  List<Object> get props => [dateTime];

}