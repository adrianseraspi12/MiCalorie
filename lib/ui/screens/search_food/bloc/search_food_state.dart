part of 'search_food_bloc.dart';

@immutable
abstract class SearchFoodState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialSearchFoodState extends SearchFoodState {}

class LoadingSearchFoodState extends SearchFoodState {}

class LoadedSearchFoodState extends SearchFoodState {
  final List<CommonFood>? listOfFood;

  LoadedSearchFoodState(this.listOfFood);

  @override
  List<Object?> get props => [listOfFood];
}

class ErrorSearchFoodState extends SearchFoodState {
  final String? errorMessage;

  ErrorSearchFoodState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
