import 'package:json_annotation/json_annotation.dart';

part 'list_of_food.g.dart';

@JsonSerializable()
class ListOfFood {

  @JsonKey(name: 'hints')
  List<CommonFood> commonFood;

  ListOfFood(this.commonFood);

  factory ListOfFood.fromJson(Map<String, dynamic> json) => _$ListOfFoodFromJson(json);

  Map<String, dynamic> toJson() => _$ListOfFoodToJson(this);

}

@JsonSerializable()
class CommonFood {

  @JsonKey(name: 'food')
  FoodDetails details;

  CommonFood(this.details);

  factory CommonFood.fromJson(Map<String, dynamic> json) => _$CommonFoodFromJson(json);

  Map<String, dynamic> toJson() => _$CommonFoodToJson(this);

}

@JsonSerializable()
class FoodDetails {

  @JsonKey(name: 'label')
  String name;

  String brand;

  Nutrients nutrients;

  FoodDetails(this.name, this.brand, this.nutrients);

  factory FoodDetails.fromJson(Map<String, dynamic> json) => _$FoodDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$FoodDetailsToJson(this);

}

@JsonSerializable()
class Nutrients {

  @JsonKey(name: 'ENERC_KCAL')
  double calories;

  @JsonKey(name: 'CHOCDF')
  double carbs;

  @JsonKey(name: 'FAT')
  double fat;

  @JsonKey(name: 'PROCNT')
  double protein;

  Nutrients(this.calories, this.carbs, this.fat, this.protein);

  factory Nutrients.fromJson(Map<String, dynamic> json) => _$NutrientsFromJson(json);

  Map<String, dynamic> toJson() => _$NutrientsToJson(this);

}
