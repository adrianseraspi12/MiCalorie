import 'package:calorie_counter/bloc/daily_summary/daily_summary_bloc.dart';
import 'package:calorie_counter/data/local/data_source/main_data_source.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
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
    return BlocProvider(
      create: (context) => DailySummaryBloc(RepositoryProvider.of<MainDataSource>(context)),
      child: Scaffold(
          backgroundColor: Color.fromRGBO(193, 214, 233, 1),
          body: SafeArea(child: DailySummaryContentScreen())),
    );
  }
}

class DailySummaryContentScreen extends StatelessWidget {
  const DailySummaryContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateTime.now();
    context.read<DailySummaryBloc>().add(ChangeTimeEvent(formattedDate));
    context.read<DailySummaryBloc>().add(LoadTotalNutrientsEvent(formattedDate));

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAppBarDate(),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildNutrientsSummary(index);
              })
        ],
      ),
    );
  }

  Widget _buildAppBarDate() {
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
              _buildDatePicker(context, dateTime);
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

  Widget _buildNutrientsSummary(int index) {
    return BlocBuilder<DailySummaryBloc, DailySummaryState>(buildWhen: (previous, state) {
      if (state is LoadedDailySummaryState || state is InitialDailySummaryState) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state is InitialDailySummaryState || state is LoadedDateTimeState) {
        return Container();
      }
      var loadedDailySummaryState = state as LoadedDailySummaryState;
      var totalNutrientsPerDay = loadedDailySummaryState.totalNutrientsPerDay;
      var mealNutrients = loadedDailySummaryState.mealNutrients;

      if (index == 0) {
        return Container(
            margin: EdgeInsets.all(16.0),
            child: NutrientPieChartView(
                calories: totalNutrientsPerDay.calories ?? 0,
                carbs: totalNutrientsPerDay.carbs ?? 0,
                fat: totalNutrientsPerDay.fat ?? 0,
                protein: totalNutrientsPerDay.protein ?? 0,
                isShowChartIfEmpty: true));
      }

      var currentMealNutrients = mealNutrients[index - 1];
      return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: MealSummaryView(
              mealNutrients: currentMealNutrients,
              onTap: () => _showMealFoodListScreen(context, currentMealNutrients)));
    });
  }

  void _showMealFoodListScreen(BuildContext buildContext, MealNutrients mealNutrients) async {
    await Navigator.of(buildContext)
        .push(MaterialPageRoute(
            builder: (context) => MealFoodListScreen(mealNutrients),
            settings: RouteSettings(name: Routes.mealFoodListScreen, arguments: Map())))
        .then((val) {
      var dateTime = DateFormat("EEEE, MMM d, yyyy").parse(val);
      buildContext.read<DailySummaryBloc>().add(LoadTotalNutrientsEvent(dateTime));
    });
  }

  void _buildDatePicker(BuildContext context, DateTime dateTime) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1920),
        lastDate: DateTime(2120));

    if (pickedDate != null) {
      context.read<DailySummaryBloc>().add(ChangeTimeEvent(pickedDate));
      context.read<DailySummaryBloc>().add(LoadTotalNutrientsEvent(pickedDate));
    }
  }
}
