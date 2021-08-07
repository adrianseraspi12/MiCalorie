import 'package:calorie_counter/ui/screens/daily_summary/bloc/daily_summary_bloc.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/widgets/list_row/meal_summary_view.dart';
import 'package:calorie_counter/ui/widgets/pie_chart/nutrient_pie_chart_view.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../meal_food_list_screen.dart';

class DailySummaryContentScreen extends StatelessWidget {
  const DailySummaryContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateTime.now();
    context.read<DailySummaryBloc>().add(ChangeTimeEvent(formattedDate));
    context.read<DailySummaryBloc>().add(LoadTotalNutrientsEvent(formattedDate));

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildNutrientsSummary(index);
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
}
