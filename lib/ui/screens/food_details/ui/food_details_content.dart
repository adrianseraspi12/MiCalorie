import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/screens/food_details/bloc/food_details_bloc.dart';
import 'package:calorie_counter/ui/widgets/neumorphic/circular_button.dart';
import 'package:calorie_counter/ui/widgets/pie_chart/nutrient_pie_chart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodDetailsContent extends StatelessWidget {
  const FoodDetailsContent({Key? key, required this.food, required this.mealNutrients})
      : super(key: key);

  final Food food;
  final MealNutrients mealNutrients;

  @override
  Widget build(BuildContext context) {
    context.read<FoodDetailsBloc>().add(SetupFoodDetailsEvent());
    return BlocListener<FoodDetailsBloc, FoodDetailsState>(
      listenWhen: (previous, state) => state is FoodSaveState,
      listener: (context, state) {
        if (state is FoodSaveState) {
          _popAndShowMessage(context, state.mealNutrients, state.message);
        }
      },
      child: _buildResults(context),
    );
  }

  Widget _buildResults(BuildContext context) {
    return BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
        buildWhen: (previous, state) => state is LoadedFoodDetailsState,
        builder: (context, state) {
          if (state is LoadedFoodDetailsState) {
            return _buildFoodDetails(context, state);
          }
          return Container();
        });
  }

  Widget _buildFoodDetails(BuildContext context, LoadedFoodDetailsState state) {
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
              onPressed: () => context.read<FoodDetailsBloc>().add(AddFoodEvent(mealNutrients)),
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
                  child: Text(food.name ?? '',
                      style: TextStyle(
                          fontFamily: 'Roboto', fontSize: 48, fontWeight: FontWeight.w700)),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(food.brandName ?? '',
                      style: TextStyle(
                          fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w400)),
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
                onPressed: () => context.read<FoodDetailsBloc>().add(DecrementEvent()),
              ),
              Neumorphic(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  padding: EdgeInsets.all(16.0),
                  style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4.0)),
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
                onPressed: () => context.read<FoodDetailsBloc>().add(IncrementEvent()),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  void _popAndShowMessage(BuildContext context, MealNutrients? mealNutrients, String message) {
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
                (route.settings.arguments as Map)['mealNutrients'] = mealNutrients;
                return true;
              }
              return false;
            }));
  }
}
