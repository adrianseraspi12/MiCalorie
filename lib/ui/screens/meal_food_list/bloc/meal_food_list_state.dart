part of 'meal_food_list_bloc.dart';

@immutable
abstract class MealFoodListState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialMealFoodListState extends MealFoodListState {}

class LoadingMealFoodListState extends MealFoodListState {}

class LoadedMealFoodListState extends MealFoodListState {
  final List<Food> listOfFood;

  LoadedMealFoodListState(this.listOfFood);

  @override
  List<Object> get props => [listOfFood];
}

class EmptyMealFoodListState extends MealFoodListState {}

class UpdateNutrientsState extends MealFoodListState {
  final bool isOnPop;

  UpdateNutrientsState(this.isOnPop);

  @override
  List<Object> get props => [isOnPop];
}
