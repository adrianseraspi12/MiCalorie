import 'package:calorie_counter/bloc/food_details/food_details_bloc.dart';
import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:calorie_counter/ui/widgets/neumorphic/circular_button.dart';
import 'package:calorie_counter/ui/widgets/pie_chart/nutrient_pie_chart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodDetailsScreen extends StatelessWidget {
  final Food food;
  final MealNutrients _mealNutrients;

  FoodDetailsScreen(this.food, this._mealNutrients);

  @override
  Widget build(BuildContext context) {
    FoodDetailsBloc foodDetailsBloc;
    return FutureBuilder<AppDatabase>(
        future: AppDatabase.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData | snapshot.hasError) {
            return Container();
          }
          var database = snapshot.data;
          var mealNutrientsRepository =
              MealNutrientsRepository(database.mealNutrientsDao);
          var foodRepository = FoodRepository(database.foodDao);
          var totalNutrientsPerDayRepo =
              TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao);
          foodDetailsBloc = FoodDetailsBloc(food, mealNutrientsRepository,
              foodRepository, totalNutrientsPerDayRepo);
          foodDetailsBloc.add(SetupFoodDetailsEvent());
          return BlocProvider<FoodDetailsBloc>(
            create: (context) => foodDetailsBloc,
            child: Scaffold(
              backgroundColor: Color.fromRGBO(193, 214, 233, 1),
              body: BlocListener<FoodDetailsBloc, FoodDetailsState>(
                  listenWhen: (previous, state) {
                    if (state is FoodSaveState) {
                      return true;
                    }
                    return false;
                  },
                  listener: (context, state) {
                    if (state is FoodSaveState) {
                      _popAndShowMessage(
                          context, state.mealNutrients, state.message);
                    }
                  },
                  child:
                      SafeArea(child: _buildResults(context, foodDetailsBloc))),
            ),
          );
        });
  }

  Widget _buildResults(BuildContext context, FoodDetailsBloc bloc) {
    return BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
        buildWhen: (previous, state) {
      if (state is FoodSaveState) {
        return false;
      }
      return true;
    }, builder: (context, state) {
      if (state is LoadedFoodDetailsState) {
        return _buildFoodDetails(context, state, bloc);
      }
      return Container();
    });
  }

  Widget _buildFoodDetails(BuildContext context, LoadedFoodDetailsState state,
      FoodDetailsBloc bloc) {
    final height = MediaQuery.of(context).size.height;
    return Column(children: <Widget>[
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
              onPressed: () => bloc.add(AddFoodEvent(_mealNutrients)),
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
                  child: Text(food.name,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 48,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(food.brandName,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ],
          )),
      NutrientPieChartView(
        calories: state.calories,
        carbs: state.carbs,
        fat: state.fat,
        protein: state.protein,
      ),
      SizedBox(
        height: height * 0.1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularButton(
                icon: Icon(Icons.remove),
                onPressed: () => bloc.add(DecrementEvent()),
              ),
              Neumorphic(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  padding: EdgeInsets.all(16.0),
                  boxShape: NeumorphicBoxShape.roundRect(
                      borderRadius: BorderRadius.circular(4.0)),
                  style: NeumorphicStyle(
                    depth: -15,
                    shadowDarkColorEmboss: Color.fromRGBO(163, 177, 198, 1),
                    shadowLightColorEmboss: Colors.white,
                    color: Color.fromRGBO(193, 214, 233, 1),
                  ),
                  child: Text(
                    '${state.count}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              CircularButton(
                icon: Icon(Icons.add),
                onPressed: () => bloc.add(IncrementEvent()),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  void _popAndShowMessage(
      BuildContext context, MealNutrients mealNutrients, String message) {
    if (message.isEmpty) {
      Navigator.popUntil(context, (route) {
        if (route.settings.name == '/mealFoodListScreen') {
          (route.settings.arguments as Map)['mealNutrients'] = mealNutrients;
          return true;
        }
        return false;
      });
      return;
    }
    Fluttertoast.showToast(msg: message, timeInSecForIosWeb: 2)
        .then((val) => Navigator.popUntil(context, (route) {
              if (route.settings.name == '/mealFoodListScreen') {
                (route.settings.arguments as Map)['mealNutrients'] =
                    mealNutrients;
                return true;
              }
              return false;
            }));
  }
}
