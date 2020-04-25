import 'package:calorie_counter/bloc/food_details_bloc.dart';
import 'package:calorie_counter/data/model/client_food.dart';
import 'package:calorie_counter/data/model/meal_summary.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/util/extension/ext_nutrient_list.dart';

class FoodDetailsScreen extends StatelessWidget {
  final ClientFood food;
  final MealSummary mealSummary;

  const FoodDetailsScreen({Key key, this.food, this.mealSummary}) : super(key: key);

  void _onAddFoodClick(BuildContext context, FoodDetailsBloc bloc) {
    bloc.addFood(mealSummary, food).then((respones) {
      // navigate to the meal food list
      //  show snackbar
      final snackBar = SnackBar(content: Text('$respones'),);
      
      Scaffold.of(context).showSnackBar(snackBar);
    })
    .catchError((e) {
      //  show snackbar
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = FoodDetailsBloc();
    _setupRepository(bloc);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white ,
              onPressed: () { _onAddFoodClick(context, bloc); })
          ]
      ),
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

  void _setupRepository(FoodDetailsBloc bloc) async {
    bloc.setupRepository();
  }

}