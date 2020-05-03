import 'package:calorie_counter/bloc/food_details_bloc.dart';
import 'package:calorie_counter/data/api/model/client_food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/widgets/circular_emboss_view.dart';
import 'package:calorie_counter/ui/widgets/pie_chart_view.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/util/extension/ext_number_rounding.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pie_chart/pie_chart.dart';

class FoodDetailsScreen extends StatelessWidget {
  final ClientFood food;
  final MealNutrients _mealNutrients;

  FoodDetailsScreen(this.food, this._mealNutrients);

  @override
  Widget build(BuildContext context) {
    final bloc = FoodDetailsBloc();
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
    Map<String, double> dataMap = Map();
    dataMap.putIfAbsent('Carbs', () => 40);
    dataMap.putIfAbsent('Fats', () => 50);
    dataMap.putIfAbsent('Protein', () => 10);

    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget> [
            SizedBox(
              height: height * 0.1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    NeumorphicButton(
                      boxShape: NeumorphicBoxShape.circle(),
                      child: Icon(Icons.chevron_left),
                      style: NeumorphicStyle(
                        shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
                        shadowLightColorEmboss: Colors.white,
                        color: Color.fromRGBO(193,214,233, 1),
                      ),
                      onClick: () {
                        Navigator.pop(context);
                      },
                    ),

                    NeumorphicButton(
                      boxShape: NeumorphicBoxShape.circle(),
                      child: Icon(Icons.add),
                      style: NeumorphicStyle(
                        shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
                        shadowLightColorEmboss: Colors.white,
                        color: Color.fromRGBO(193,214,233, 1),
                      ),
                      onClick: () {
                        _onAddFoodClick(context, bloc); 
                      },
                    )
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
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
                        food.name,
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
                child: CircularEmbossView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '170',
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
                                child: CircularEmbossView(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      child: Text(
                                        '4g',
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
                                child: CircularEmbossView(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      child: Text(
                                        '4g',
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
                                child: CircularEmbossView(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      child: Text(
                                        '4g',
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
                    NeumorphicButton(
                      boxShape: NeumorphicBoxShape.circle(),
                      child: Icon(Icons.add),
                      style: NeumorphicStyle(
                        shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
                        shadowLightColorEmboss: Colors.white,
                        color: Color.fromRGBO(193,214,233, 1),
                      ),
                      onClick: () {

                      },
                    ),

                    Neumorphic(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      padding: EdgeInsets.all(16.0),
                      boxShape: NeumorphicBoxShape.roundRect(borderRadius: BorderRadius.circular(4.0)),
                      style: NeumorphicStyle(
                        depth: -10,
                        shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
                        shadowLightColorEmboss: Colors.white,
                        color: Color.fromRGBO(193,214,233, 1),
                      ),
                      child: Text(
                        '22',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),)
                    ),

                    NeumorphicButton(
                      boxShape: NeumorphicBoxShape.circle(),
                      child: Icon(Icons.remove),
                      style: NeumorphicStyle(
                        shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
                        shadowLightColorEmboss: Colors.white,
                        color: Color.fromRGBO(193,214,233, 1),
                      ),
                      onClick: () {

                      },
                    ),

                  ],
                ),

              ),
            ),

        ]),
      ),
    );
  }

}