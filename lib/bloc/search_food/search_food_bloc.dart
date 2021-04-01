import 'dart:io';

import 'package:calorie_counter/data/api/client/edaman_client.dart';
import 'package:calorie_counter/data/api/interceptor/connection_interceptor.dart';
import 'package:calorie_counter/data/api/model/list_of_food.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_food_event.dart';

part 'search_food_state.dart';

class SearchFoodBloc extends Bloc<SearchFoodEvent, SearchFoodState> {
  final EdamanClient edamanClient;

  SearchFoodBloc(this.edamanClient) : super(InitialSearchFoodState());

  @override
  Stream<SearchFoodState> mapEventToState(SearchFoodEvent event) async* {
    if (event is SearchFoodQueryEvent) {
      String query = event.query;
      if (query.isEmpty) {
        return;
      }
      yield LoadingSearchFoodState();
      try {
        final results = await edamanClient.searchFood(query);

        if (results.data == null || results.data.commonFood == null) {
          yield ErrorSearchFoodState(results.errorMessage);
          return;
        } else if (results.data.commonFood.length == 0) {
          yield ErrorSearchFoodState('No food found');
          return;
        } else {
          yield LoadedSearchFoodState(results.data.commonFood);
        }
      } on NoInternetConnectionException catch (error) {
        yield ErrorSearchFoodState(error.message);
      } on SocketException catch (_) {
        yield ErrorSearchFoodState('Something went wrong.\nPlease try again');
      }
    }
  }
}
