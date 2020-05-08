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
  Stream<List<Food>> get foodListStream => _foodListController.stream;
  final int mealId;
  List<Food> listOfFood;

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
    listOfFood.remove(food);
    _foodListController.sink.add(listOfFood);
  }

  void removeFood(Food food) {
    _updateNutrients(food);
    _foodRepository.remove(food);
  }

  void _updateNutrients(Food food) async {
    final numberOfServings = food.numOfServings;

    final calories = food.calories * numberOfServings;
    final carbs = food.carbs * numberOfServings;
    final fat = food.fat * numberOfServings;
    final protein = food.protein * numberOfServings;
    
    final currentMeal = await _mealNutrientsRepository.getMeal(mealId);
    final totalNutrientsPerDayId = currentMeal.totalNutrientsPerDayId;

    _updateMeal(currentMeal, calories, carbs, fat, protein);
    _updateTotalNutrients(totalNutrientsPerDayId, calories, carbs, fat, protein);
  }

  void _updateTotalNutrients(int totalNutrientsId, int calories, int carbs, int fat, int protein) async {
    final totalNutrientsPerDay = await _dayRepository.getTotalNutrientsById(totalNutrientsId);

    final updatedTotalNutrients = TotalNutrientsPerDay(
      totalNutrientsPerDay.id,
      totalNutrientsPerDay.date,
      totalNutrientsPerDay.calories - calories, 
      totalNutrientsPerDay.carbs - carbs, 
      totalNutrientsPerDay.fat - fat,
      totalNutrientsPerDay.protein - protein);

    _dayRepository.upsert(updatedTotalNutrients);
  }

  void _updateMeal(MealNutrients meal, int calories, int carbs, int fat, int protein) async {
    final mealNutrients = MealNutrients(
      meal.id, 
      meal.calories - calories, 
      meal.carbs - carbs, 
      meal.fat - fat, 
      meal.protein - protein, 
      meal.type, 
      meal.totalNutrientsPerDayId);

    _mealNutrientsRepository.upsert(mealNutrients);
  }

  @override
  void dispose() {
    _foodListController.close();
  }

}