part of 'meal_food_list_bloc.dart';

@immutable
abstract class MealFoodListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SetupFoodListEvent extends MealFoodListEvent {
  final MealNutrients mealNutrients;

  SetupFoodListEvent(this.mealNutrients);

  @override
  List<Object> get props => [mealNutrients];
}

class RetainFoodListEvent extends MealFoodListEvent {
  final int index;
  final Food food;

  RetainFoodListEvent(this.index, this.food);

  @override
  List<Object> get props => [index, food];
}

class TempRemoveFoodEvent extends MealFoodListEvent {
  final Food food;

  TempRemoveFoodEvent(this.food);

  @override
  List<Object> get props => [food];
}

class RemoveFood extends MealFoodListEvent {
  final bool isOnPop;

  RemoveFood(this.isOnPop);

  @override
  List<Object> get props => [isOnPop];
}
