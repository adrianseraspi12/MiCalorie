import 'package:calorie_counter/data/api/model/client_food.dart';
import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:calorie_counter/util/extension/ext_number_rounding.dart';
import 'package:rxdart/subjects.dart';

import 'bloc.dart';

class FoodDetailsBloc implements Bloc {

  final ClientFood _clientFood;
  var currentCount = 1;
  
  FoodDetailsBloc(this._clientFood);

  final _mealNutrientsController = PublishSubject<MealNutrients>();
  final _foodDetailsCountController = PublishSubject<FoodDetailsCountResult>();

  Stream<FoodDetailsCountResult> get foodDetailsCountStream => _foodDetailsCountController.stream;
  Stream<MealNutrients> get mealNutrientsStream => _mealNutrientsController.stream;

  MealNutrientsRepository _mealNutrientsRepository;
  FoodRepository _foodRepository;
  TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;

  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _foodRepository = FoodRepository(database.foodDao);
    _mealNutrientsRepository = MealNutrientsRepository(database.mealNutrientsDao);
    _totalNutrientsPerDayRepository = TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
  }

  void addFood(MealNutrients mealSummary, ClientFood food) async {
    _updateTotalNutrientsAndMeal(mealSummary, food);
  }
    
  void increment() {
    currentCount += 1;
    if (currentCount > 0) {
      _foodDetailsCountController.sink.add(_calculateTheFoodDetails(currentCount));
    }

  }

  void decrement() {
    currentCount -= 1;
    if (currentCount > 0) {
      _foodDetailsCountController.sink.add(_calculateTheFoodDetails(currentCount));
    }
    else {
      currentCount = 1;
    }
  }

  
  FoodDetailsCountResult _calculateTheFoodDetails(int count) {
    final newCalories = _clientFood.nutrients.calories.roundTo(0) * count;
    final newCarbs = _clientFood.nutrients.carbs.roundTo(0) * count;
    final newFat = _clientFood.nutrients.fat.roundTo(0) * count;
    final newProtein = _clientFood.nutrients.protein.roundTo(0) * count;     

    return FoodDetailsCountResult(
      newCalories, 
      newCarbs, 
      newFat, 
      newProtein, 
      count
    );
  }

  void _updateTotalNutrientsAndMeal(MealNutrients mealNutrients, ClientFood food) async {
    var totalNutrientsPerDay = await _totalNutrientsPerDayRepository.getTotalNutrientsByDate(mealNutrients.date);
    var totalNutrientsId;

    if (totalNutrientsPerDay == null) {
      totalNutrientsId = mealNutrients.totalNutrientsPerDayId;
      
      final currentTotalNutrients = TotalNutrientsPerDay(mealNutrients.totalNutrientsPerDayId,
        mealNutrients.date, 
        food.nutrients.calories.toInt(),
        food.nutrients.carbs.roundTo(0),
        food.nutrients.fat.roundTo(0),
        food.nutrients.protein.roundTo(0));
      
      _totalNutrientsPerDayRepository.upsert(currentTotalNutrients);
    }
    else {
      totalNutrientsId = totalNutrientsPerDay.id;

      var foodNutrients = food.nutrients;
      var newCalories = totalNutrientsPerDay.calories + foodNutrients.calories.roundTo(0);
      var newCarbs = totalNutrientsPerDay.carbs + foodNutrients.carbs;
      var newFat = totalNutrientsPerDay.fat + foodNutrients.fat;
      var newProtein = totalNutrientsPerDay.protein + foodNutrients.protein;

      final newTotalNutrientsPerDay = TotalNutrientsPerDay(
        totalNutrientsPerDay.id, 
        totalNutrientsPerDay.date, 
        newCalories,
        newCarbs.roundTo(0), 
        newFat.roundTo(0), 
        newProtein.roundTo(0));

      _totalNutrientsPerDayRepository.upsert(newTotalNutrientsPerDay);
    }

    _updateMeal(totalNutrientsId, mealNutrients, food);
  }

  void _updateMeal(int totalNutrientsPerDayId, MealNutrients mealNutrients, ClientFood food) async {
    final currentMealNutrients = await _mealNutrientsRepository.getMeal(mealNutrients.id);

    if (currentMealNutrients == null) {
      var id = await _mealNutrientsRepository.getAllMealCount();
      id += 1;

      final newMealNutrients = MealNutrients(
        id, 
        food.nutrients.calories.toInt(),
        food.nutrients.carbs.roundTo(0),
        food.nutrients.fat.roundTo(0),
        food.nutrients.protein.roundTo(0),
        mealNutrients.type, 
        totalNutrientsPerDayId,
        date: mealNutrients.date);

      _mealNutrientsRepository.upsert(newMealNutrients);
      _insertFood(newMealNutrients, food);
    }
    else {
      final foodNutrients = food.nutrients;
      final newCalories = currentMealNutrients.calories + foodNutrients.calories.toInt();
      final newCarbs = currentMealNutrients.carbs + foodNutrients.carbs;
      final newFat = currentMealNutrients.fat + foodNutrients.fat;
      final newProtein = currentMealNutrients.protein + foodNutrients.protein;
    
      final updateMealNutrients = MealNutrients(
        currentMealNutrients.id, 
        newCalories, 
        newCarbs.roundTo(0), 
        newFat.roundTo(0), 
        newProtein.roundTo(0), 
        currentMealNutrients.type, 
        totalNutrientsPerDayId,
        date: mealNutrients.date);

      _mealNutrientsRepository.upsert(updateMealNutrients);
      _insertFood(updateMealNutrients, food);
    }

  }

  void _insertFood(MealNutrients mealNutrients, ClientFood clientFood) async {
    final foodId = await _foodRepository.getAllFoodCount();
    final currentFoodId = foodId + 1;

    final food = Food(currentFoodId,
    mealNutrients.id, 
    clientFood.name,
    currentCount, 
    clientFood.brand, 
    clientFood.nutrients.calories.toInt(),
    clientFood.nutrients.carbs.roundTo(0),
    clientFood.nutrients.fat.roundTo(0),
    clientFood.nutrients.protein.roundTo(0));

    _foodRepository.upsert(food);
    _mealNutrientsController.sink.add(mealNutrients);
  }

  @override
  void dispose() {
    _mealNutrientsController.close();
    _foodDetailsCountController.close();
  }

}

enum NutrientDataType {

  CALORIES,
  CARBS,
  FAT,
  PROTEIN

}

class FoodDetailsCountResult {

  int calories;
  int carbs;
  int fat;
  int protein;
  int count;

  FoodDetailsCountResult(this.calories, this.carbs, this.fat, this.protein, this.count);

}