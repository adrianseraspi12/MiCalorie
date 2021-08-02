import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/util/extension/ext_meal_type_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MealSummaryView extends StatelessWidget {
  MealSummaryView({Key key, this.mealNutrients, this.onTap});

  final MealNutrients mealNutrients;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      onPressed: onTap,
      style: NeumorphicStyle(
        shape: NeumorphicShape.convex,
        shadowDarkColorEmboss: Color.fromRGBO(163, 177, 198, 1),
        shadowLightColorEmboss: Colors.white,
        color: Color.fromRGBO(193, 214, 233, 1),
      ),
      child: Column(
        children: <Widget>[
          _buildMealTypeAndCalorie(),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 9,
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildNutrient('Carbs', mealNutrients.carbs),
                    _buildNutrient('Fat', mealNutrients.fat),
                    _buildNutrient('Protein', mealNutrients.protein)
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Neumorphic(
                  child: Icon(Icons.chevron_right),
                  style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.circle(),
                    shape: NeumorphicShape.convex,
                    shadowDarkColorEmboss: Color.fromRGBO(163, 177, 198, 1),
                    shadowLightColorEmboss: Colors.white,
                    color: Color.fromRGBO(193, 214, 233, 1),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeAndCalorie() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('${mealNutrients.type.description()}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              )),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                child: Text('${mealNutrients.calories}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrient(String mealType, int nutrientCount) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
          child: Column(
            children: <Widget>[
              FittedBox(
                child: Text(
                  '${nutrientCount}g',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                mealType,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
