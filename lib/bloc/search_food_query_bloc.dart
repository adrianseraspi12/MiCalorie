import 'dart:async';
import 'dart:io';
import 'package:calorie_counter/data/api/client/edaman_client.dart';
import 'package:calorie_counter/data/api/interceptor/connection_interceptor.dart';
import 'package:calorie_counter/data/api/model/list_of_food.dart';
import 'package:rxdart/rxdart.dart';


import 'bloc.dart';

class SearchFoodQueryBloc implements Bloc {

  final _commonFoodController = PublishSubject<SearchResult>();

  final _edamanClient = EdamanClient();

  Stream<SearchResult> get commonFoodStream => _commonFoodController.stream;

  void setUpClient() async {
    await _edamanClient.setUpClient();
  }

  void submitQuery(String query) async {
    _commonFoodController.sink.add(SearchResult(null, null, true));
    
    if (query == null || query.isEmpty) {
      return;
    }

    try {

      final results = await _edamanClient.searchFood(query);
      SearchResult searchResult; 

      if (results.data == null || results.data.commonFood == null) {
        searchResult = SearchResult(null, results.errorMessage, false);
      }
      else if (results.data.commonFood.length == 0) {
        searchResult = SearchResult(null, 'No food found', false);
      }
      else {
        searchResult = SearchResult(results.data.commonFood, null, false);
      }
      _commonFoodController.sink.add(searchResult);
    } on NoInternetConnectionException catch(error) {
      var searchResult = SearchResult(null, error.message, false);
      _commonFoodController.sink.add(searchResult);
    } on SocketException catch(_) {
      var searchResult = SearchResult(null, 'Something went wrong.\nPlease try again', false);
      _commonFoodController.sink.add(searchResult);
    }

  }

  @override
  void dispose() {
    _commonFoodController.close();
  }

}

class SearchResult {

  List<CommonFood> listOfFood;
  bool isLoading;
  String errorMessage;

  SearchResult(this.listOfFood, this.errorMessage, this.isLoading);

}