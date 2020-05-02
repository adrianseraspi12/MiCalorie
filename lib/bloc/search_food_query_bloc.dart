import 'dart:async';
import 'package:calorie_counter/data/api/client/edaman_client.dart';
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
    final results = await _edamanClient.searchFood(query);
    SearchResult searchResult; 
  
    if (results.data == null || results.data.commonFood == null) {
      searchResult = SearchResult(null, results.errorMessage);
    }
    else if (results.data.commonFood.length == 0) {
      searchResult = SearchResult(null, 'No food found');
    }
    else {
      searchResult = SearchResult(results.data.commonFood, null);
    }

    _commonFoodController.sink.add(searchResult);
  }

  @override
  void dispose() {
    _commonFoodController.close();
  }

}

class SearchResult {

  List<CommonFood> listOfFood;
  String errorMessage;

  SearchResult(this.listOfFood, this.errorMessage);

}