import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';

extension MealNutrientsList on List<MealNutrients> {

  bool containsType(int type) {
    var mealNutrients = this.firstWhere((meal) => meal.type == type, orElse: () => null);

    if (mealNutrients != null) {
      return true;
    }
    else {
      return false;
    }
  }

}