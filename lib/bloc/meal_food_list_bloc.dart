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
    // final listOfFood = await _foodRepository.getAllFoods();
    // List<Food> listOfFood = [];
    // listOfFood.add(Food(0, 0, 'Egg', 1, 'Large', 20, 0, 0, 15));
    // listOfFood.add(Food(0, 0, 'Cake', 3, 'Small', 200, 5, 12, 2));
    // listOfFood.add(Food(0, 0, 'Protein Shake', 1, 'Medium', 14, 6, 8, 20));
    // listOfFood.add(Food(0, 0, 'Fish', 1, 'Small', 132, 1, 2, 34));
    // listOfFood.add(Food(0, 0, 'Pancake', 1, 'Small', 100, 5, 5, 2));
    // listOfFood.add(Food(0, 0, 'Egg White', 1, 'Small', 20, 0, 0, 10));
    _foodListController.sink.add(listOfFood);
  }

  @override
  void dispose() {
    _foodListController.close();
  }

}