import 'package:calorie_counter/bloc/food_details_bloc.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/model/client_food.dart';
import 'package:calorie_counter/data/model/meal_summary.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/util/extension/ext_nutrient_list.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodDetailsScreen extends StatelessWidget {
  final ClientFood food;
  final MealNutrients _mealNutrients;

  FoodDetailsScreen(this.food, this._mealNutrients);

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
                  _onAddFoodClick(context, bloc); 
                }),
            )
          ]
      ),
      body: _buildResult(context, bloc)
    );
  }

  void _onAddFoodClick(BuildContext context, FoodDetailsBloc bloc) async {
    bloc.addFood(_mealNutrients, food);
  }

  void _setupRepository(FoodDetailsBloc bloc) async {
    bloc.setupRepository();
  }

  Widget _buildResult(BuildContext context, FoodDetailsBloc bloc) {

    return StreamBuilder<MealNutrients>(
      stream: bloc.mealNutrientsStream,
      builder: (context, snapshot) {

        final mealSummary = snapshot.data;

        if (mealSummary != null) {
          _popAndShowMessage(context, mealSummary);
          return Container();
        }
        else {
          return _buildFoodDetails();
        }


      },
    
    );

  }

  void _popAndShowMessage(BuildContext context, MealNutrients mealNutrients) {
    Fluttertoast.showToast(
      msg: 'Food added',
      timeInSecForIosWeb: 2)
      .then((val) => Navigator.popUntil(
        context,
        (route) {
          if (route.settings.name == '/mealFoodListScreen') {
            (route.settings.arguments as Map) ['mealNutrients'] = mealNutrients;
            return true;
          }
          return false;
        })
      );
  }

  Widget _buildFoodDetails() {
    return ListView(
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
      );
  }

}