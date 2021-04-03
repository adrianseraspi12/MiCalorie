part of 'food_details_bloc.dart';

@immutable
abstract class FoodDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialFoodDetailsState extends FoodDetailsState {}

class LoadingFoodDetailsState extends FoodDetailsState {}

class LoadedFoodDetailsState extends FoodDetailsState {
  final int calories;
  final int carbs;
  final int fat;
  final int protein;
  final int count;

  LoadedFoodDetailsState(
      this.calories, this.carbs, this.fat, this.protein, this.count);
}

class FoodSaveState extends FoodDetailsState {
  final MealNutrients mealNutrients;
  final String message;

  FoodSaveState(this.mealNutrients, this.message);

  @override
  List<Object> get props => [mealNutrients, message];
}
