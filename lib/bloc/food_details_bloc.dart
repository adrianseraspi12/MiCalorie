import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/breakfast_nutrients.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/lunch_nutrients.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/data/local/repository/breakfast_repository.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:calorie_counter/data/local/repository/lunch_repository.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:calorie_counter/data/model/client_food.dart';
import 'package:calorie_counter/data/model/meal_summary.dart';
import 'package:calorie_counter/util/extension/ext_nutrient_list.dart';
import 'package:calorie_counter/util/extension/ext_number_rounding.dart';
import 'package:rxdart/subjects.dart';

import 'bloc.dart';

class FoodDetailsBloc implements Bloc {

  final _mealNutrientsController = PublishSubject<MealNutrients>();
  Stream<MealNutrients> get mealNutrientsStream => _mealNutrientsController.stream;

  MealNutrientsRepository _mealNutrientsRepository;
  FoodRepository _foodRepository;
  BreakfastRepository _breakfastNutrientsRepository;
  LunchRepository _lunchRepository;
  TotalNutrientsPerDayRepository _totalNutrientsPerDayRepository;

  void setupRepository() async {
    final database = await AppDatabase.getInstance();
    _foodRepository = FoodRepository(database.foodDao);
    _breakfastNutrientsRepository = BreakfastRepository(database.breakfastNutrientsDao);
    _lunchRepository = LunchRepository(database.lunchNutrientsDao);
    _mealNutrientsRepository = MealNutrientsRepository(database.mealNutrientsDao);
    _totalNutrientsPerDayRepository = TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
  }

  void addFood(MealNutrients mealSummary, ClientFood food) async {
    _updateTotalNutrientsAndMeal(mealSummary, food);
  }
    
  void _updateTotalNutrientsAndMeal(MealNutrients mealNutrients, ClientFood food) async {
    var totalNutrientsPerDay = await _totalNutrientsPerDayRepository.getTotalNutrientsByDate(mealNutrients.date);
    var totalNutrientsId;

    if (totalNutrientsPerDay == null) {
      totalNutrientsId = mealNutrients.totalNutrientsPerDayId;
      
      final currentTotalNutrients = TotalNutrientsPerDay(mealNutrients.totalNutrientsPerDayId,
        mealNutrients.date, 
        food.nutrients.getNutrient(NutrientType.calories).toInt(),
        food.nutrients.getNutrient(NutrientType.carbs),
        food.nutrients.getNutrient(NutrientType.fat),
        food.nutrients.getNutrient(NutrientType.protein));
      
      _totalNutrientsPerDayRepository.upsert(currentTotalNutrients);
    }
    else {
      totalNutrientsId = totalNutrientsPerDay.id;

      var foodNutrients = food.nutrients;
      var newCalories = totalNutrientsPerDay.calories + foodNutrients.getNutrient(NutrientType.calories).toInt();
      var newCarbs = totalNutrientsPerDay.carbs + foodNutrients.getNutrient(NutrientType.carbs);
      var newFat = totalNutrientsPerDay.fat + foodNutrients.getNutrient(NutrientType.fat);
      var newProtein = totalNutrientsPerDay.protein + foodNutrients.getNutrient(NutrientType.protein);

      final newTotalNutrientsPerDay = TotalNutrientsPerDay(
        totalNutrientsPerDay.id, 
        totalNutrientsPerDay.date, 
        newCalories,
        newCarbs.roundTo(2), 
        newFat.roundTo(2), 
        newProtein.roundTo(2));

      _totalNutrientsPerDayRepository.upsert(newTotalNutrientsPerDay);
    }

    // mealNutrients.totalNutrientsPerDayId = totalNutrientsId;

    _updateMeal(totalNutrientsId, mealNutrients, food);
    // _updateMeal(mealSummary, food);
  }

  void _updateMeal(int totalNutrientsPerDayId, MealNutrients mealNutrients, ClientFood food) async {
    final currentMealNutrients = await _mealNutrientsRepository.getMeal(mealNutrients.id);

    if (currentMealNutrients == null) {
      var id = await _mealNutrientsRepository.getAllMealCount();
      id += 1;

      final newMealNutrients = MealNutrients(
        id, 
        food.nutrients.getNutrient(NutrientType.calories).toInt(),
        food.nutrients.getNutrient(NutrientType.carbs),
        food.nutrients.getNutrient(NutrientType.fat),
        food.nutrients.getNutrient(NutrientType.protein),
        mealNutrients.type, 
        totalNutrientsPerDayId,
        date: mealNutrients.date);

      _mealNutrientsRepository.upsert(newMealNutrients);
      _insertFood(newMealNutrients, food);
    }
    else {
      final foodNutrients = food.nutrients;
      final newCalories = currentMealNutrients.calories + foodNutrients.getNutrient(NutrientType.calories).toInt();
      final newCarbs = currentMealNutrients.carbs + foodNutrients.getNutrient(NutrientType.carbs);
      final newFat = currentMealNutrients.fat + foodNutrients.getNutrient(NutrientType.fat);
      final newProtein = currentMealNutrients.protein + foodNutrients.getNutrient(NutrientType.protein);
    
      final updateMealNutrients = MealNutrients(
        currentMealNutrients.id, 
        newCalories, 
        newCarbs.roundTo(2), 
        newFat.roundTo(2), 
        newProtein.roundTo(2), 
        currentMealNutrients.type, 
        totalNutrientsPerDayId,
        date: mealNutrients.date);

      _mealNutrientsRepository.upsert(updateMealNutrients);
      _insertFood(updateMealNutrients, food);
    }

  }

  // void _updateMeal(MealSummary mealSummary, ClientFood food) async {
    
  //   if (mealSummary.name == 'Breakfast') {
  //     _updateBreakfast(mealSummary, food);
  //   }
  //   else if (mealSummary.name == 'Lunch') {
  //     _updateLunch(mealSummary, food);
  //   }

  // }

  // void _updateBreakfast(MealSummary mealSummary, ClientFood food) async {
  //   final breakfastNutrients = await _breakfastNutrientsRepository.getBreakfast(mealSummary.id);

  //     if (breakfastNutrients == null) {
  //       final id = await _breakfastNutrientsRepository.getTotalBreakfastCount();
        
  //       var currentId = id + 1;
  //       mealSummary.id = currentId;

  //       final breakfast = BreakfastNutrients(currentId,
  //       food.nutrients.getNutrient(NutrientType.calories).toInt(),
  //       food.nutrients.getNutrient(NutrientType.carbs),
  //       food.nutrients.getNutrient(NutrientType.fat),
  //       food.nutrients.getNutrient(NutrientType.protein),
  //       mealSummary.totalNutrientsId);

  //       _breakfastNutrientsRepository.upsert(breakfast);
  //     }
  //     else {
  //       var currentId = breakfastNutrients.id;
  //       mealSummary.id = currentId;

  //       final foodNutrients = food.nutrients;
  //       final newCalories = breakfastNutrients.calories + foodNutrients.getNutrient(NutrientType.calories).toInt();
  //       final newCarbs = breakfastNutrients.carbs + foodNutrients.getNutrient(NutrientType.carbs);
  //       final newFat = breakfastNutrients.fat + foodNutrients.getNutrient(NutrientType.fat);
  //       final newProtein = breakfastNutrients.protein + foodNutrients.getNutrient(NutrientType.protein);

  //       final newBreakfastNutrients = BreakfastNutrients(
  //         breakfastNutrients.id, 
  //         newCalories, 
  //         newCarbs.roundTo(2), 
  //         newFat.roundTo(2), 
  //         newProtein.roundTo(2), 
  //         breakfastNutrients.totalNutrientsPerDayId);

  //       _breakfastNutrientsRepository.upsert(newBreakfastNutrients);
  //     }

  //   _insertFood(mealSummary, food);
  // }

  // void _updateLunch(MealSummary mealSummary, ClientFood food) async {
  //   final lunchNutrients = await _lunchRepository.getLunch(mealSummary.id);

  //     if (lunchNutrients == null) {
  //       final id = await _lunchRepository.getTotalLunchCount();
        
  //       var currentId = id + 1;
  //       mealSummary.id = currentId;

  //       final lunch = LunchNutrients(currentId,
  //       food.nutrients.getNutrient(NutrientType.calories).toInt(),
  //       food.nutrients.getNutrient(NutrientType.carbs),
  //       food.nutrients.getNutrient(NutrientType.fat),
  //       food.nutrients.getNutrient(NutrientType.protein),
  //       mealSummary.totalNutrientsId);

  //       _lunchRepository.upsert(lunch);
  //     }
  //     else {
  //       var currentId = lunchNutrients.id;
  //       mealSummary.id = currentId;

  //       final foodNutrients = food.nutrients;
  //       final newCalories = lunchNutrients.calories + foodNutrients.getNutrient(NutrientType.calories).toInt();
  //       final newCarbs = lunchNutrients.carbs + foodNutrients.getNutrient(NutrientType.carbs);
  //       final newFat = lunchNutrients.fat + foodNutrients.getNutrient(NutrientType.fat);
  //       final newProtein = lunchNutrients.protein + foodNutrients.getNutrient(NutrientType.protein);

  //       final newLunchNutrients = LunchNutrients(
  //         lunchNutrients.id, 
  //         newCalories, 
  //         newCarbs.roundTo(2), 
  //         newFat.roundTo(2), 
  //         newProtein.roundTo(2), 
  //         lunchNutrients.totalNutrientsPerDayId);

  //       _lunchRepository.upsert(newLunchNutrients);
  //     }

  //   _insertFood(mealSummary, food);
  // }

  void _insertFood(MealNutrients mealNutrients, ClientFood clientFood) async {
    final foodId = await _foodRepository.getAllFoodCount();
    final currentFoodId = foodId + 1;

    final food = Food(currentFoodId,
    mealNutrients.id, 
    clientFood.name, 
    clientFood.numberOfServings, 
    clientFood.servingSize, 
    clientFood.nutrients.getNutrient(NutrientType.calories).toInt(),
    clientFood.nutrients.getNutrient(NutrientType.carbs),
    clientFood.nutrients.getNutrient(NutrientType.fat),
    clientFood.nutrients.getNutrient(NutrientType.protein));

    _foodRepository.upsert(food);
    _mealNutrientsController.sink.add(mealNutrients);
  }

  @override
  void dispose() {
    _mealNutrientsController.close();
  }

}