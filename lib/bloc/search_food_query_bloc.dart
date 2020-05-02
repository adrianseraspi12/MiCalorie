import 'dart:async';
import 'package:calorie_counter/data/api/client/nutritionx_client.dart';
import 'package:calorie_counter/data/api/model/list_of_food.dart';
import 'package:rxdart/rxdart.dart';


import 'bloc.dart';

class SearchFoodQueryBloc implements Bloc {

  final _commonFoodController = BehaviorSubject<List<CommonFood>>();
  final _brandedFoodController = BehaviorSubject<List<BrandedFood>>();

  final _nutritionxClient = NutritionxClient();

  Stream<List<CommonFood>> get commonFoodStream => _commonFoodController.stream;
  Stream<List<BrandedFood>> get brandedFoodStream => _brandedFoodController.stream;

  void setUpClient() async {
    await _nutritionxClient.setUpClient();
  }

  void submitQuery(String query) async {
    final results = await _nutritionxClient.searchFood(query);
    _commonFoodController.sink.add(results.commonFood);
    _brandedFoodController.sink.add(results.brandedFood);
  }

  @override
  void dispose() {
    _commonFoodController.close();
    _brandedFoodController.close();
  }

}