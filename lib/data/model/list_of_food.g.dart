// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_of_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOfFood _$ListOfFoodFromJson(Map<String, dynamic> json) {
  return ListOfFood(
    (json['common'] as List)
        ?.map((e) =>
            e == null ? null : CommonFood.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['branded'] as List)
        ?.map((e) =>
            e == null ? null : BrandedFood.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListOfFoodToJson(ListOfFood instance) =>
    <String, dynamic>{
      'common': instance.commonFood,
      'branded': instance.brandedFood,
    };

CommonFood _$CommonFoodFromJson(Map<String, dynamic> json) {
  return CommonFood(
    json['food_name'] as String,
    json['serving_unit'] as String,
    json['serving_qty'] as int,
    json['photo'] == null
        ? null
        : Photo.fromJson(json['photo'] as Map<String, dynamic>),
    (json['full_nutrients'] as List)
        ?.map((e) =>
            e == null ? null : Nutrients.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CommonFoodToJson(CommonFood instance) =>
    <String, dynamic>{
      'food_name': instance.foodName,
      'serving_unit': instance.servingUnit,
      'serving_qty': instance.servingQty,
      'photo': instance.photo,
      'full_nutrients': instance.nutrients,
    };

BrandedFood _$BrandedFoodFromJson(Map<String, dynamic> json) {
  return BrandedFood(
    json['nix_item_id'] as String,
    json['food_name'] as String,
    json['brand_name'] as String,
    json['photo'] == null
        ? null
        : Photo.fromJson(json['photo'] as Map<String, dynamic>),
    (json['full_nutrients'] as List)
        ?.map((e) =>
            e == null ? null : Nutrients.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BrandedFoodToJson(BrandedFood instance) =>
    <String, dynamic>{
      'nix_item_id': instance.nixItemId,
      'food_name': instance.foodName,
      'brand_name': instance.brandName,
      'photo': instance.photo,
      'full_nutrients': instance.nutrients,
    };

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return Photo(
    json['thumb'] as String,
  );
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'thumb': instance.url,
    };

Nutrients _$NutrientsFromJson(Map<String, dynamic> json) {
  return Nutrients(
    json['attr_id'] as int,
    (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$NutrientsToJson(Nutrients instance) => <String, dynamic>{
      'attr_id': instance.attrId,
      'value': instance.value,
    };
