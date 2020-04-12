import 'package:calorie_counter/data/model/list_of_food.dart';

class Food {

  String name;
  int numberOfServings;
  String servingSize;
  List<Nutrients> nutrients;

  Food({this.name, this.numberOfServings, this.servingSize, this.nutrients});

}