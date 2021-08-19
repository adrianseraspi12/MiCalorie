part of 'search_food_bloc.dart';

@immutable
abstract class SearchFoodEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchFoodQueryEvent extends SearchFoodEvent {
  final String query;

  SearchFoodQueryEvent(this.query);

  @override
  List<Object> get props => [query];
}
