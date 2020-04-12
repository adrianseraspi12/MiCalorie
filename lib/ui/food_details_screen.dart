import 'package:calorie_counter/data/model/food.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/util/extension/ext_nutrient_list.dart';

class FoodDetailsScreen extends StatelessWidget {
  final Food food;

  const FoodDetailsScreen({Key key, this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),  
            child: Text('${food.name}')
          ),

          Divider(),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Number of servings'),
                Text('${food.numberOfServings}')
              ]
            ),
          ),

          Divider(),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Serving size'),
                Text('${food.servingSize}')
              ]
            ),
          ),

          Divider(),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              
              Column(
                children: <Widget>[
                Text('${food.nutrients.getNutrient(NutrientType.carbs)} g'),
                Text('Carbs')
              ]),

              Container(
                height: 20.0,
                child: VerticalDivider(
                  color: Colors.black,
                  width: 5.0,),
              ),

              Column(children: <Widget>[
                Text('${food.nutrients.getNutrient(NutrientType.fat)} g'),
                Text('Fat')
              ]),

              Container(
                height: 20.0,
                child: VerticalDivider(
                  color: Colors.black,
                  width: 5.0,),
              ),

              Column(children: <Widget>[
                Text('${food.nutrients.getNutrient(NutrientType.protein)} g'),
                Text('Protein'),
              ]),

              Container(
                height: 20.0,
                child: VerticalDivider(
                  color: Colors.black,
                  width: 5.0,),
              ),

              Column(children: <Widget>[
                Text('${food.nutrients.getNutrient(NutrientType.calories)}'),
                Text('Calories'),
              ]),

            ]),
          ),

          Divider(),

        ],
      )
    );
  }
}