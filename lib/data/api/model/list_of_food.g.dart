// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_of_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOfFood _$ListOfFoodFromJson(Map<String, dynamic> json) {
  return ListOfFood(
    (json['hints'] as List)
        ?.map((e) =>
            e == null ? null : CommonFood.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListOfFoodToJson(ListOfFood instance) =>
    <String, dynamic>{
      'hints': instance.commonFood,
    };

CommonFood _$CommonFoodFromJson(Map<String, dynamic> json) {
  return CommonFood(
    json['food'] == null
        ? null
        : FoodDetails.fromJson(json['food'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CommonFoodToJson(CommonFood instance) =>
    <String, dynamic>{
      'food': instance.details,
    };

FoodDetails _$FoodDetailsFromJson(Map<String, dynamic> json) {
  return FoodDetails(
    json['label'] as String,
    json['brand'] as String,
    json['nutrients'] == null
        ? null
        : Nutrients.fromJson(json['nutrients'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FoodDetailsToJson(FoodDetails instance) =>
    <String, dynamic>{
      'label': instance.name,
      'brand': instance.brand,
      'nutrients': instance.nutrients,
    };

Nutrients _$NutrientsFromJson(Map<String, dynamic> json) {
  return Nutrients(
    (json['ENERC_KCAL'] as num)?.toDouble(),
    (json['CHOCDF'] as num)?.toDouble(),
    (json['FAT'] as num)?.toDouble(),
    (json['PROCNT'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$NutrientsToJson(Nutrients instance) => <String, dynamic>{
      'ENERC_KCAL': instance.calories,
      'CHOCDF': instance.carbs,
      'FAT': instance.fat,
      'PROCNT': instance.protein,
    };
