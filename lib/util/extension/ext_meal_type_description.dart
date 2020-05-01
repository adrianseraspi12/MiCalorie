import 'package:calorie_counter/util/constant/meal_type.dart';

extension MealTypeDescription on int {

  String description() {
    if (this == MealType.BREAKFAST) {
      return 'Breakfast';
    }
    else if (this == MealType.LUNCH) {
      return 'Lunch';
    }
    else if (this == MealType.DINNER) {
      return 'Dinner';
    }
    else if (this == MealType.SNACK) {
      return 'Snack';
    }
    else {
      return '';
    }

  }

}