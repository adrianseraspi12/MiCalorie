import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:rxdart/subjects.dart';

import 'bloc.dart';

class MealFoodListBloc implements Bloc {

  final _foodListController = PublishSubject<List<Food>>();
  Stream<List<Food>> get foodListStream => _foodListController.stream;
  final int mealId;

  FoodRepository _foodRepository;

  MealFoodListBloc(this.mealId);

  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _foodRepository = FoodRepository(database.foodDao);
    setupFoodList();
  }

  void setupFoodList() async {
    final listOfFood = await _foodRepository.findAllDataWith(mealId);
    _foodListController.sink.add(listOfFood);
  }

  @override
  void dispose() {
    _foodListController.close();
  }

}