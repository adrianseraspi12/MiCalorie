part of 'quick_add_food_bloc.dart';

@immutable
abstract class QuickAddFoodEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddFoodEvent extends QuickAddFoodEvent {}
