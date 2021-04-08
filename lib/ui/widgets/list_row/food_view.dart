import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FoodView extends StatelessWidget {
  FoodView({Key key, this.food, this.onTap});

  final Food food;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      onClick: onTap,
      style: NeumorphicStyle(
        depth: 2,
        shadowLightColor: Colors.white,
        shadowDarkColor: Color.fromRGBO(163, 177, 198, 1),
        color: Color.fromRGBO(193, 214, 233, 1),
      ),
      child: ListTile(
        title: Text('${food.name}'),
        subtitle: Text('${food.brandName}'),
        trailing: Text('${food.numOfServings}'),
      ),
    );
  }
}
