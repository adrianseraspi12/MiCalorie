import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:rxdart/subjects.dart';

import 'bloc.dart';

class MealFoodListBloc implements Bloc {

  final _foodListController = PublishSubject<List<Food>>();
  Stream<List<Food>> get foodListStream => _foodListController.stream;
  final int mealId;
  List<Food> listOfFood;
  Food tempFood;

  FoodRepository _foodRepository;

  MealFoodListBloc(this.mealId);

  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _foodRepository = FoodRepository(database.foodDao);
    setupFoodList();
  }

  void setupFoodList() async {
    listOfFood = await _foodRepository.findAllDataWith(mealId);

    if (tempRemoveFood != null) {
      listOfFood.remove(tempRemoveFood);
    }

    _foodListController.sink.add(listOfFood);
  }

  void tempRemoveFood(Food food) {
    this.tempFood = food;
    listOfFood.remove(food);
    _foodListController.sink.add(listOfFood);
  }

  void removeFood() {

  }

  @override
  void dispose() {
    _foodListController.close();
  }

}