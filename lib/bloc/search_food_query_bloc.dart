import 'dart:async';

import 'package:calorie_counter/data/model/list_of_food.dart';
import 'package:calorie_counter/data/nutritionx_client.dart';

import 'bloc.dart';

class SearchFoodQueryBloc implements Bloc {

  final _controller = StreamController<ListOfFood>();
  final _nutritionxClient = NutritionxClient();
  Stream<ListOfFood> get listOfFoodStream => _controller.stream;

  void setUpClient() async {
    await _nutritionxClient.setUpClient();
  }

  void submitQuery(String query) async {
    final results = await _nutritionxClient.searchFood(query);
    print("FOOD NAME = ${results.commonFood}");
    _controller.sink.add(results);
  }

  @override
  void dispose() {
    _controller.close();
  }

}