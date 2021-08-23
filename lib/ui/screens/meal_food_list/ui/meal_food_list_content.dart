import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/screens/food_details/ui/food_details_screen.dart';
import 'package:calorie_counter/ui/screens/meal_food_list/bloc/meal_food_list_bloc.dart';
import 'package:calorie_counter/ui/widgets/image_view.dart';
import 'package:calorie_counter/ui/widgets/list_row/food_view.dart';
import 'package:calorie_counter/ui/widgets/modal.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealFoodListContent extends StatelessWidget {
  const MealFoodListContent({Key? key, required this.showSnackbar, required this.hideSnackbar});

  final Function(VoidCallback, VoidCallback) showSnackbar;
  final VoidCallback hideSnackbar;

  @override
  Widget build(BuildContext context) {
    Modal modal = Modal();
    return BlocBuilder<MealFoodListBloc, MealFoodListState>(
        buildWhen: (previous, current) => !(current is UpdateNutrientsState),
        builder: (blocContext, state) {
          if (state is EmptyMealFoodListState) {
            final assetName = 'assets/images/signs.svg';
            return ImageView(
              resourceName: assetName,
              height: 100,
              width: 100,
              caption: 'No saved foods',
            );
          } else if (state is LoadedMealFoodListState) {
            var listOfFood = state.listOfFood;
            return ListView.builder(
                itemCount: listOfFood.length,
                itemBuilder: (context, index) {
                  final food = listOfFood[index];
                  return FoodView(
                    food: food,
                    onTap: () {
                      final titles = ['View Food', 'Remove Food'];
                      final actions = [
                        _viewFoodCallback(blocContext, food),
                        _removeFoodCallback(blocContext, index, food)
                      ];
                      modal.bottomSheet(blocContext, titles, actions);
                    },
                  );
                });
          }
          return Container();
        });
  }

  VoidCallback _viewFoodCallback(BuildContext context, Food food) {
    return () {
      context.read<MealFoodListBloc>().add(RemoveFood(false));
      hideSnackbar();
      _showFoodDetails(context, food);
    };
  }

  VoidCallback _removeFoodCallback(BuildContext buildContext, int index, Food food) {
    return () {
      buildContext.read<MealFoodListBloc>().add(TempRemoveFoodEvent(food));
      showSnackbar(() {
        hideSnackbar();
        buildContext.read<MealFoodListBloc>().add(RetainFoodListEvent(index, food));
      }, () {
        buildContext.read<MealFoodListBloc>().add(RemoveFood(false));
      });
    };
  }

  void _showFoodDetails(BuildContext buildContext, Food food) {
    var route = MaterialPageRoute(
        builder: (BuildContext context) =>
            FoodDetailsScreen(food, buildContext.read<MealFoodListBloc>().mealNutrients),
        settings: RouteSettings(name: Routes.foodDetailsScreen));

    Navigator.of(buildContext).push(route).then((val) {
      _retainData(buildContext);
    });
  }

  void _retainData(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final retainMealNutrients = arguments['mealNutrients'] as MealNutrients?;
    if (retainMealNutrients != null) {
      context.read<MealFoodListBloc>().add(SetupFoodListEvent(retainMealNutrients));
      context.read<MealFoodListBloc>().date = retainMealNutrients.date;
    }
  }
}
