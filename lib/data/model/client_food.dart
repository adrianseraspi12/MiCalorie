import 'package:calorie_counter/data/model/list_of_food.dart';

class ClientFood {

  String name;
  int numberOfServings;
  String servingSize;
  List<Nutrients> nutrients;

  ClientFood({this.name, this.numberOfServings, this.servingSize, this.nutrients});

}