import 'package:calorie_counter/data/api/model/list_of_food.dart';

import 'ext_number_rounding.dart';

extension NutrientList on List<Nutrients> {

  static const Map<NutrientType, int> _nutrientTypeAttrId = {
    NutrientType.carbs: 205,
    NutrientType.fat: 204,
    NutrientType.protein: 203,
    NutrientType.calories: 208
  };

  double getNutrient(NutrientType type) {
    final attrId = _nutrientTypeAttrId[type];
    final nutrient =  this.firstWhere((element) {
      return element.attrId == attrId;
    });

    var value = nutrient.value;
    return value.roundTo(2);
  }
    
}
    
enum NutrientType {
  
  carbs,
  fat,
  protein,
  calories

}
