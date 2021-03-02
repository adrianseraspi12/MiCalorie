part of 'quick_add_food_bloc.dart';

@immutable
abstract class QuickAddFoodState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialQuickAddFoodState extends QuickAddFoodState {}

class LoadingQuickAddFoodState extends QuickAddFoodState {}

class LoadedQuickAddFoodState extends QuickAddFoodState {}

class ErrorQuickAddFoodState extends QuickAddFoodState {
  ErrorQuickAddFoodState(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
