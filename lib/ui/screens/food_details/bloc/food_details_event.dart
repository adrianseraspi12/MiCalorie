part of 'food_details_bloc.dart';

abstract class FoodDetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddFoodEvent extends FoodDetailsEvent {
  final MealNutrients mealNutrients;

  AddFoodEvent(this.mealNutrients);

  @override
  List<Object> get props => [mealNutrients];
}

class IncrementEvent extends FoodDetailsEvent {}

class DecrementEvent extends FoodDetailsEvent {}

class SetupFoodDetailsEvent extends FoodDetailsEvent {}
