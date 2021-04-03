import 'package:calorie_counter/bloc/daily_summary/daily_summary_bloc.dart';
import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:calorie_counter/util/extension/ext_meal_type_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

import 'meal_food_list_screen.dart';
import '../widgets/pie_chart/nutrient_pie_chart_view.dart';

class DailySummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DailySummaryBloc dailySummaryBloc;

    return FutureBuilder<AppDatabase>(
      future: AppDatabase.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Container();
        }
        final database = snapshot.data;
        dailySummaryBloc = DailySummaryBloc(
            TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao),
            MealNutrientsRepository(database.mealNutrientsDao));

        final formattedDate = DateTime.now();
        dailySummaryBloc.add(ChangeTimeEvent(formattedDate));
        dailySummaryBloc.add(LoadTotalNutrientsEvent(formattedDate));
        return BlocProvider<DailySummaryBloc>(
          create: (context) => dailySummaryBloc,
          child: Scaffold(
              backgroundColor: Color.fromRGBO(193, 214, 233, 1),
              body: SafeArea(child: _buildResult(context, dailySummaryBloc))),
        );
      },
    );
  }

  Widget _buildResult(BuildContext context, DailySummaryBloc dailySummaryBloc) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAppBarDate(context, dailySummaryBloc),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildNutrientsSummary(context, index, dailySummaryBloc);
              })
        ],
      ),
    );
  }

  void _showMealFoodListScreen(BuildContext context,
      MealNutrients mealNutrients, DailySummaryBloc bloc) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => MealFoodListScreen(mealNutrients),
            settings: RouteSettings(
                name: Routes.mealFoodListScreen, arguments: Map())))
        .then((val) {
      var dateTime = DateFormat("EEEE, MMM d, yyyy").parse(val);
      bloc.add(LoadTotalNutrientsEvent(dateTime));
    });
  }

  void _buildDatePicker(
      BuildContext context, DateTime dateTime, DailySummaryBloc bloc) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1920),
        lastDate: DateTime(2120));

    if (pickedDate != null) {
      bloc.add(ChangeTimeEvent(pickedDate));
      bloc.add(LoadTotalNutrientsEvent(pickedDate));
    }
  }

  Widget _buildAppBarDate(BuildContext context, DailySummaryBloc bloc) {
    return BlocBuilder<DailySummaryBloc, DailySummaryState>(
        buildWhen: (previous, state) {
      if (state is LoadedDateTimeState) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state is InitialDailySummaryState) {
        return Container();
      }
      var dailySummaryBloc = state as LoadedDateTimeState;
      var dateTimeString = dailySummaryBloc.dateTimeString;
      var dateTime = dailySummaryBloc.dateTime;

      return Container(
        margin: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
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
              _buildDatePicker(context, dateTime, bloc);
            },
            style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              shadowDarkColorEmboss: Color.fromRGBO(163, 177, 198, 1),
              shadowLightColorEmboss: Colors.white,
              color: Color.fromRGBO(193, 214, 233, 1),
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
                          dateTimeString,
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
                    shadowDarkColorEmboss: Color.fromRGBO(163, 177, 198, 1),
                    shadowLightColorEmboss: Colors.white,
                    color: Color.fromRGBO(193, 214, 233, 1),
                  ),
                )
              ],
            ),
          ),
        ]),
      );
    });
  }

  Widget _buildNutrientsSummary(
      BuildContext context, int index, DailySummaryBloc bloc) {
    return BlocBuilder<DailySummaryBloc, DailySummaryState>(
        buildWhen: (previous, state) {
      if (state is LoadedDailySummaryState ||
          state is InitialDailySummaryState) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state is InitialDailySummaryState) {
        return Container();
      }
      var loadedDailySummaryState = state as LoadedDailySummaryState;
      var totalNutrientsPerDay = loadedDailySummaryState.totalNutrientsPerDay;
      var mealNutrients = loadedDailySummaryState.mealNutrients;

      if (index == 0) {
        return Container(
            margin: EdgeInsets.all(16.0),
            child: NutrientPieChartView(
                calories: totalNutrientsPerDay.calories,
                carbs: totalNutrientsPerDay.carbs,
                fat: totalNutrientsPerDay.fat,
                protein: totalNutrientsPerDay.protein,
                isShowChartIfEmpty: true));
      }

      return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: _buildMealSummary(context, bloc, mealNutrients[index - 1]));
    });
  }

  Widget _buildMealSummary(BuildContext context, DailySummaryBloc bloc,
      MealNutrients mealNutrients) {
    return NeumorphicButton(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      onClick: () => _showMealFoodListScreen(context, mealNutrients, bloc),
      style: NeumorphicStyle(
        shape: NeumorphicShape.convex,
        shadowDarkColorEmboss: Color.fromRGBO(163, 177, 198, 1),
        shadowLightColorEmboss: Colors.white,
        color: Color.fromRGBO(193, 214, 233, 1),
      ),
      child: Column(
        children: <Widget>[
          Container(
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
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
}