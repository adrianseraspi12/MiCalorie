import 'package:calorie_counter/bloc/daily_summary/daily_summary_bloc.dart';
import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/injection.dart';
import 'package:calorie_counter/ui/widgets/list_row/meal_summary_view.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

import '../widgets/pie_chart/nutrient_pie_chart_view.dart';
import 'meal_food_list_screen.dart';

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
        dailySummaryBloc = DailySummaryBloc(Injection.provideMainDataSource(database));

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

  Widget _buildAppBarDate(BuildContext context, DailySummaryBloc bloc) {
    return BlocBuilder<DailySummaryBloc, DailySummaryState>(buildWhen: (previous, state) {
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
            onPressed: () {
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
                  child: Icon(Icons.chevron_right),
                  style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.circle(),
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

  Widget _buildNutrientsSummary(BuildContext context, int index, DailySummaryBloc bloc) {
    return BlocBuilder<DailySummaryBloc, DailySummaryState>(buildWhen: (previous, state) {
      if (state is LoadedDailySummaryState || state is InitialDailySummaryState) {
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

      var currentMealNutrients = mealNutrients[index - 1];
      return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: MealSummaryView(
              mealNutrients: currentMealNutrients,
              onTap: () => _showMealFoodListScreen(context, currentMealNutrients, bloc)));
    });
  }

  void _showMealFoodListScreen(
      BuildContext context, MealNutrients mealNutrients, DailySummaryBloc bloc) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => MealFoodListScreen(mealNutrients),
            settings: RouteSettings(name: Routes.mealFoodListScreen, arguments: Map())))
        .then((val) {
      var dateTime = DateFormat("EEEE, MMM d, yyyy").parse(val);
      bloc.add(LoadTotalNutrientsEvent(dateTime));
    });
  }

  void _buildDatePicker(BuildContext context, DateTime dateTime, DailySummaryBloc bloc) async {
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
}
