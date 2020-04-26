import 'package:calorie_counter/bloc/food_details_bloc.dart';
import 'package:calorie_counter/data/model/client_food.dart';
import 'package:calorie_counter/data/model/meal_summary.dart';
import 'package:calorie_counter/ui/routes.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/util/extension/ext_nutrient_list.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodDetailsScreen extends StatelessWidget {
  final ClientFood food;
  final MealSummary mealSummary;

  const FoodDetailsScreen({Key key, this.food, this.mealSummary}) : super(key: key);

  void _onAddFoodClick(FoodDetailsBloc bloc) async {
    bloc.addFood(mealSummary, food);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = FoodDetailsBloc();
    _setupRepository(bloc);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.add),
                color: Colors.white ,
                onPressed: () {
                  _onAddFoodClick(bloc); 
                  Fluttertoast.showToast(
                    msg: 'Food added',
                    timeInSecForIosWeb: 2)
                    .then( 
                    (val) => Navigator.popUntil(context, (r) => r.settings.name == Routes.mealFoodListScreen)
                  );
                }),
            )
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