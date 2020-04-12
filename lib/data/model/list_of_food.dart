import 'package:json_annotation/json_annotation.dart';

part 'list_of_food.g.dart';

@JsonSerializable()
class ListOfFood {

  @JsonKey(name: 'common')
  List<CommonFood> commonFood;

  @JsonKey(name: 'branded')
  List<BrandedFood> brandedFood;

  ListOfFood(this.commonFood, this.brandedFood);

  factory ListOfFood.fromJson(Map<String, dynamic> json) => _$ListOfFoodFromJson(json);

  Map<String, dynamic> toJson() => _$ListOfFoodToJson(this);

}

@JsonSerializable()
class CommonFood {

  @JsonKey(name: 'food_name')
  String foodName;
    
  @JsonKey(name: 'serving_unit')
  String servingUnit;

  @JsonKey(name: 'serving_qty')
  int servingQty;

  Photo photo;

  @JsonKey(name: 'full_nutrients')
  List<Nutrients> nutrients;

  CommonFood(this.foodName, this.servingUnit, this.servingQty, this.photo, this.nutrients);

  factory CommonFood.fromJson(Map<String, dynamic> json) => _$CommonFoodFromJson(json);

  Map<String, dynamic> toJson() => _$CommonFoodToJson(this);

}

@JsonSerializable()
class BrandedFood {

  @JsonKey(name: 'nix_item_id')
  String nixItemId;

  @JsonKey(name: 'food_name')
  String foodName;

  @JsonKey(name: 'brand_name')
  String brandName;

  @JsonKey(name: 'serving_unit')
  String servingUnit;

  @JsonKey(name: 'serving_qty')
  int servingQty;

  Photo photo;

  @JsonKey(name: 'full_nutrients')
  List<Nutrients> nutrients;

  BrandedFood(this.nixItemId, this.foodName, this.brandName, this.servingUnit, this.servingQty, this.photo, this.nutrients);

  factory BrandedFood.fromJson(Map<String, dynamic> json) => _$BrandedFoodFromJson(json);

  Map<String, dynamic> toJson() => _$BrandedFoodToJson(this);

}

@JsonSerializable()
class Photo {

  @JsonKey(name: 'thumb')
  String url;

  Photo(this.url);

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);

}

@JsonSerializable()
class Nutrients {

  @JsonKey(name: 'attr_id')
  int attrId;

  @JsonKey(name: 'value')
  double value;

  Nutrients(this.attrId, this.value);

  factory Nutrients.fromJson(Map<String, dynamic> json) => _$NutrientsFromJson(json);

  Map<String, dynamic> toJson() => _$NutrientsToJson(this);

}
