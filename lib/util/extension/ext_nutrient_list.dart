import 'package:calorie_counter/data/model/list_of_food.dart';

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

    return nutrient.value;
  }
    
}
    
enum NutrientType {
  
  carbs,
  fat,
  protein,
  calories

}
