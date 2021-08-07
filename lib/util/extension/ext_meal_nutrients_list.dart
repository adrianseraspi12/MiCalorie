import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';

extension MealNutrientsList on List<MealNutrients> {
  bool containsType(int type) {
    MealNutrients mealNutrients = this.firstWhere((meal) => meal.type == type,
        orElse: () => MealNutrients(-100, null, null, null, null, null, null));

    if (mealNutrients.id != -100) {
      return true;
    } else {
      return false;
    }
  }
}
