import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:rxdart/subjects.dart';

import 'bloc.dart';

class MealFoodListBloc implements Bloc {

  final _foodListController = PublishSubject<List<Food>>();
  final _updateNutrientsOnPopController = PublishSubject<bool>();

  Stream<bool> get updateNutrientsOnPopStream => _updateNutrientsOnPopController.stream;
  Stream<List<Food>> get foodListStream => _foodListController.stream;
  int mealId;
  List<Food> listOfFood;
  Food tempFood;

  TotalNutrientsPerDayRepository _dayRepository;
  MealNutrientsRepository _mealNutrientsRepository;
  FoodRepository _foodRepository;

  MealFoodListBloc(this.mealId);

  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _foodRepository = FoodRepository(database.foodDao);
    _dayRepository = TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
    _mealNutrientsRepository = MealNutrientsRepository(database.mealNutrientsDao);
    setupFoodList();
  }

  void setupFoodList() async {
    listOfFood = await _foodRepository.findAllDataWith(mealId);
    _foodListController.sink.add(listOfFood);
  }

  void retainFoodList(int index, Food food) {
    listOfFood.insert(index, food);
    _foodListController.sink.add(listOfFood);
  }

  void tempRemoveFood(Food food) {
    tempFood = food;
    listOfFood.remove(food);
    _foodListController.sink.add(listOfFood);
  }

  void removeFood() {
    _removeFoodWithCallback(null);
  }

  void removeFoodOnPop() {
    if (tempFood == null) {
      _updateNutrientsOnPopController.sink.add(true);
    }
    else {
      
    }
    _removeFoodWithCallback(() => _updateNutrientsOnPopController.sink.add(true));
  }

  void _removeFoodWithCallback(Function callback) {
    if (tempFood != null) {
      _updateNutrients(tempFood, callback);
      _foodRepository.remove(tempFood);
      tempFood = null;
    }
  }

  void _updateNutrients(Food food, Function onDelete) async {
    final numberOfServings = food.numOfServings;

    final calories = food.calories * numberOfServings;
    final carbs = food.carbs * numberOfServings;
    final fat = food.fat * numberOfServings;
    final protein = food.protein * numberOfServings;
    
    final currentMeal = await _mealNutrientsRepository.getMeal(mealId);
    final totalNutrientsPerDayId = currentMeal.totalNutrientsPerDayId;

    _updateTotalNutrients(
      totalNutrientsPerDayId, 
      currentMeal, 
      calories,
      carbs, 
      fat, 
      protein,
      onDelete);
  }

  void _updateTotalNutrients(
    int totalNutrientsId,
    MealNutrients meal, 
    int calories, 
    int carbs, 
    int fat, 
    int protein,
    Function callback) async {

    final totalNutrientsPerDay = await _dayRepository.getTotalNutrientsById(totalNutrientsId);

    final updatedTotalNutrients = TotalNutrientsPerDay(
      totalNutrientsPerDay.id,
      totalNutrientsPerDay.date,
      totalNutrientsPerDay.calories - calories, 
      totalNutrientsPerDay.carbs - carbs, 
      totalNutrientsPerDay.fat - fat,
      totalNutrientsPerDay.protein - protein);

    _dayRepository.upsert(updatedTotalNutrients)
      .then( (val) {
        _updateMeal(meal, calories, carbs, fat, protein, callback);
      }
    );
  }

  void _updateMeal(MealNutrients meal, int calories, int carbs, int fat, int protein, Function callback) async {
    final mealNutrients = MealNutrients(
      meal.id, 
      meal.calories - calories, 
      meal.carbs - carbs, 
      meal.fat - fat, 
      meal.protein - protein, 
      meal.type, 
      meal.totalNutrientsPerDayId);

    _mealNutrientsRepository.upsert(mealNutrients);

    if (callback != null) {
      callback();
    }
  }

  @override
  void dispose() {
    _foodListController.close();
    _updateNutrientsOnPopController.close();
  }

}