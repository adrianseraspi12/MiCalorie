import 'dart:async';

import 'package:calorie_counter/bloc/bloc.dart';
import 'package:calorie_counter/data/api/model/list_of_food.dart';


class FoodBloc implements Bloc {

  ListOfFood _listOfFood;

  final _foodController = StreamController<ListOfFood>();
  Stream<ListOfFood> get listOfFoodStream => _foodController.stream;

  @override
  void dispose() {
    _foodController.close();
  }

}