import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/daily_summary_bloc.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/widgets/nutrient_pie_chart_view.dart';
import 'package:calorie_counter/util/extension/ext_meal_type_description.dart';
import 'package:calorie_counter/ui/meal_food_list_screen.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class DailySummaryScreen extends StatefulWidget {
  
  @override
  _DailySummaryScreenState createState() => _DailySummaryScreenState();
}

class _DailySummaryScreenState extends State<DailySummaryScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final bloc = DailySummaryBloc();
    _setupData(bloc);

    return BlocProvider<DailySummaryBloc>(
      bloc: bloc,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(193,214,233, 1),
        body: _buildResult(context, bloc)
      ),
    );
  }

  void _setupData(DailySummaryBloc bloc) async {
    bloc.setupRepository();
  }

  Widget _buildAppBarDate(BuildContext context, DailySummaryBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.dateTimeStream,
      builder: (context, snapshot) {

        var date = snapshot.data;

        if (date == null) {
          date = 'Today';
        }

        return Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget> [
              Center(
                child: FittedBox(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Daily Summary',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              NeumorphicButton(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.symmetric(horizontal: 60.0, vertical: 8.0),
                onClick: () { 
                  _buildDatePicker(context, bloc);
                },
                style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
                  shadowLightColorEmboss: Colors.white,
                  color: Color.fromRGBO(193,214,233, 1),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Date:',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: FittedBox(
                            child: Text(
                              '$date',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Neumorphic(
                      boxShape: NeumorphicBoxShape.circle(),
                      child: Icon(Icons.chevron_right),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
                        shadowLightColorEmboss: Colors.white,
                        color: Color.fromRGBO(193,214,233, 1),
                      ),
                    )

                  ],
                ),
              ),
              
            ]
          ),
        );
      }
    );
  }

  void _buildDatePicker(BuildContext context, DailySummaryBloc bloc) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate, 
      firstDate: DateTime(1920), 
      lastDate: DateTime(2120));

    if (pickedDate != null) {
      selectedDate = pickedDate;
      bloc.updateTimeAndTotalNutrients(pickedDate);
    }

  }

  Widget _buildResult(BuildContext context, DailySummaryBloc bloc) {
    return StreamBuilder<DailySummaryResult>(
      stream: bloc.dailySummaryResultStream,
      builder: (context, snapshot) {

        final dailySummaryResult = snapshot.data;

        final calories = dailySummaryResult.totalNutrientsPerDay.calories;
        final carbs = dailySummaryResult.totalNutrientsPerDay.carbs;
        final fat = dailySummaryResult.totalNutrientsPerDay.fat;
        final protein = dailySummaryResult.totalNutrientsPerDay.protein;

        if (dailySummaryResult == null) {
          return Center(child: Text('DATA UNAVAILABLE'));
        }
        else {
          return ListView.builder(
            itemCount: dailySummaryResult.mealNutrients.length + 2,
            itemBuilder: (context, index) {

              if (index == 0) {
                return _buildAppBarDate(context, bloc);
              }
              else if (index == 1) {
                return Container(
                  margin: EdgeInsets.all(16.0),
                  child: NutrientPieChartView(
                    calories: calories,
                    carbs: carbs, 
                    fat: fat, 
                    protein: protein)
                );
              }

              index -= 2;

              var mealNutrients = dailySummaryResult.mealNutrients[index];

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: _buildMealSummary(context, bloc, mealNutrients)
              );

            });
        }

      });
  }

  Widget _buildMealSummary(BuildContext context, DailySummaryBloc bloc, MealNutrients mealNutrients) {
    
    return NeumorphicButton(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      onClick: () => _showMealFoodListScreen(context, mealNutrients, bloc),
      style: NeumorphicStyle(
        shape: NeumorphicShape.convex,
        shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
        shadowLightColorEmboss: Colors.white,
        color: Color.fromRGBO(193,214,233, 1),
      ),
      child: Column(
        
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${mealNutrients.type.description()}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  )
                ),
                
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      child: Text(
                        '${mealNutrients.calories}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        )
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

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

                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                          child: Column(
                            children: <Widget>[
                              FittedBox(
                                child: Text(
                                  '${mealNutrients.carbs}g',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                'Carbs',
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
                    ),

                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                          child: Column(
                            children: <Widget>[
                              FittedBox(
                                child: Text(
                                  '${mealNutrients.fat}g',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                'Fat',
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
                    ),

                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                          child: Column(
                            children: <Widget>[
                              FittedBox(
                                child: Text(
                                  '${mealNutrients.protein}g',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                'Protein',
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
                    ),

                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: Neumorphic(
                  boxShape: NeumorphicBoxShape.circle(),
                  child: Icon(Icons.chevron_right),
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
                    shadowLightColorEmboss: Colors.white,
                    color: Color.fromRGBO(193,214,233, 1),
                  ),
                ),
              )

            ],
          ),

        ],

      ),
    );
  }

  void _showMealFoodListScreen(BuildContext context, MealNutrients mealNutrients, DailySummaryBloc bloc) async {
    var date = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealFoodListScreen(mealNutrients),
        settings: RouteSettings(name: Routes.mealFoodListScreen,
                                arguments: Map())
      )
    );
    bloc.changeTotalNutrients(date);
  }

}