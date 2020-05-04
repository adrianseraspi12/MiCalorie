import 'package:calorie_counter/bloc/food_details_bloc.dart';
import 'package:calorie_counter/data/api/model/client_food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/widgets/circular_button.dart';
import 'package:calorie_counter/ui/widgets/circular_emboss_view.dart';
import 'package:calorie_counter/ui/widgets/pie_chart_view.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/util/extension/ext_number_rounding.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodDetailsScreen extends StatelessWidget {
  final ClientFood food;
  final MealNutrients _mealNutrients;

  FoodDetailsScreen(this.food, this._mealNutrients);

  @override
  Widget build(BuildContext context) {
    final bloc = FoodDetailsBloc(food);
    _setupRepository(bloc);

    return Scaffold(
      backgroundColor: Color.fromRGBO(193,214,233, 1),
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
          return _buildFoodDetails(context, bloc);
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

  Widget _buildFoodDetails(BuildContext context, FoodDetailsBloc bloc) {
    var fullNutrientsData = bloc.getNutrientPercentage();
    final calorieColors = [Colors.green, Colors.red, Colors.blue];
    final carbsColor =[Colors.green, Colors.transparent];
    final fatColor =[Colors.red, Colors.transparent];
    final proteinColor =[Colors.blue, Colors.transparent];


    final height = MediaQuery.of(context).size.height;

    return StreamBuilder<FoodDetailsCountResult>(
      stream: bloc.foodDetailsCountStream,
      builder: (context, snapshot) {

        final result = snapshot.data;
        var calories;
        var carbs;
        var fat;
        var protein;
        var count;

        if (result == null) {
          calories = food.nutrients.calories.roundTo(0);
          carbs = food.nutrients.carbs.roundTo(0);
          fat = food.nutrients.fat.roundTo(0);
          protein = food.nutrients.protein.roundTo(0);
          count = 1;
        }
        else {
          calories = result.calories;
          carbs = result.carbs;
          fat = result.fat;
          protein = result.protein;
          count = result.count;
        }

        return SafeArea(
          child: Container(
            child: Column(
              children: <Widget> [
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircularButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: () => Navigator.pop(context),
                      ),

                      CircularButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _onAddFoodClick(context, bloc),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  child: Column(
                    children: <Widget>[
                       Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            food.name,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 48,
                              fontWeight: FontWeight.w700)
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            food.brand,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w400)
                          ),
                        ),
                      ),

                    ],
                  )
                ),

                SizedBox(
                  height: height * 0.35,
                  child: PieChartView(
                    listOfColor: calorieColors,
                    data: fullNutrientsData[NutrientDataType.CALORIES],
                    child: CircularEmbossView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$calories',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Calories',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ]
                      ),
                    )
                  ),
                ),

                SizedBox(
                  height: height * 0.25,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),  
                                  child: PieChartView(
                                    listOfColor: carbsColor,
                                    data: fullNutrientsData[NutrientDataType.CARBS],
                                    child: CircularEmbossView(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          child: Text(
                                            '${carbs}g',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )
                                      )
                                    ),
                                  ),
                                ),
                              ),

                              Text(
                                'Carbs',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                )
                              )
                            ]
                          )
                        ),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),  
                                  child: PieChartView(
                                    listOfColor: fatColor,
                                    data: fullNutrientsData[NutrientDataType.FAT],
                                    child: CircularEmbossView(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          child: Text(
                                            '${fat}g',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )
                                      )
                                    ),
                                  ),
                                ),
                              ),

                              Text(
                                'Fat',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                )
                              )
                            ]
                          )
                        ),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),  
                                  child: PieChartView(
                                    listOfColor: proteinColor,
                                    data: fullNutrientsData[NutrientDataType.PROTEIN],
                                    child: CircularEmbossView(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          child: Text(
                                            '${protein}g',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )
                                      )
                                    ),
                                  ),
                                ),
                              ),

                              Text(
                                'Protein',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                )
                              )
                            ]
                          )
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: height * 0.1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularButton(
                          icon: Icon(Icons.add),
                          onPressed: () => bloc.increment(),
                        ),

                        Neumorphic(
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          padding: EdgeInsets.all(16.0),
                          boxShape: NeumorphicBoxShape.roundRect(borderRadius: BorderRadius.circular(4.0)),
                          style: NeumorphicStyle(
                            depth: -15,
                            shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
                            shadowLightColorEmboss: Colors.white,
                            color: Color.fromRGBO(193,214,233, 1),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),)
                        ),

                        CircularButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => bloc.decrement(),
                        ),
                      ],
                    ),

                  ),
                ),

            ]),
          ),
        );
      }
    );
  }

}