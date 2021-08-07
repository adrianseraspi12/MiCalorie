import 'package:calorie_counter/bloc/meal_food_list/meal_food_list_bloc.dart';
import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/injection.dart';
import 'package:calorie_counter/ui/screens/quick_add_food_screen.dart';
import 'package:calorie_counter/ui/screens/search_food_screen.dart';
import 'package:calorie_counter/ui/widgets/image_view.dart';
import 'package:calorie_counter/ui/widgets/list_row/food_view.dart';
import 'package:calorie_counter/ui/widgets/modal.dart';
import 'package:calorie_counter/ui/widgets/neumorphic/circular_button.dart';
import 'package:calorie_counter/ui/widgets/snackbar.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:calorie_counter/util/extension/ext_meal_type_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'food_details_screen.dart';

class MealFoodListScreen extends StatelessWidget {
  final modal = Modal();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final MealNutrients mealNutrients;

  MealFoodListScreen(this.mealNutrients);

  @override
  Widget build(BuildContext context) {
    MealFoodListBloc? mealFoodListBloc;
    Snackbar snackbar = Snackbar(_scaffoldKey);
    return WillPopScope(
      onWillPop: () async {
        snackbar.removeSnackbar();
        mealFoodListBloc!.add(RemoveFood(true));
        return false;
      },
      child: FutureBuilder<AppDatabase>(
          future: AppDatabase.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Container();
            }
            var database = snapshot.data!;
            mealFoodListBloc =
                MealFoodListBloc(Injection.provideMainDataSource(database), mealNutrients);
            mealFoodListBloc!.add(SetupFoodListEvent(mealNutrients));
            mealFoodListBloc!.date = mealNutrients.date;
            return BlocProvider<MealFoodListBloc>(
              create: (context) => mealFoodListBloc!,
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: Color.fromRGBO(193, 214, 233, 1),
                body: BlocListener<MealFoodListBloc, MealFoodListState>(
                  listenWhen: (previous, state) {
                    if (state is UpdateNutrientsState) {
                      return true;
                    }
                    return false;
                  },
                  listener: (context, state) {
                    if (state is UpdateNutrientsState) {
                      snackbar.removeSnackbar();
                      if (state.isOnPop) {
                        Navigator.pop(context, mealFoodListBloc!.date);
                      }
                    }
                  },
                  child: SafeArea(
                      child: Column(
                    children: [
                      _buildAppbar(context, mealFoodListBloc, snackbar),
                      Expanded(child: _buildResults(mealFoodListBloc, snackbar))
                    ],
                  )),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildAppbar(BuildContext context, MealFoodListBloc? bloc, Snackbar snackbar) {
    return Neumorphic(
      margin: EdgeInsets.only(bottom: 4.0),
      padding: EdgeInsets.all(16.0),
      style: NeumorphicStyle(
        shadowLightColor: Color.fromRGBO(193, 214, 233, 1),
        color: Color.fromRGBO(193, 214, 233, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CircularButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              bloc!.add(RemoveFood(true));
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 8.0),
                child: FittedBox(
                  child: Text(
                    '${mealNutrients.type.description()}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          CircularButton(
            icon: Icon(Icons.add),
            onPressed: () {
              final titles = ['Quick Add', 'Search Food'];
              final actions = [
                () {
                  snackbar.removeSnackbar();
                  bloc!.add(RemoveFood(false));
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuickAddFoodScreen(bloc.mealNutrients),
                              settings: RouteSettings(name: Routes.quickAddFoodScreen)))
                      .then((value) => _retainData(context, bloc));
                },
                () {
                  snackbar.removeSnackbar();
                  bloc!.add(RemoveFood(false));
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => SearchFoodScreen(mealNutrients),
                          settings: RouteSettings(name: Routes.searchFoodScreen)))
                      .then((v) => _retainData(context, bloc));
                }
              ];

              modal.bottomSheet(context, titles, actions);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResults(MealFoodListBloc? bloc, Snackbar snackbar) {
    return BlocBuilder<MealFoodListBloc, MealFoodListState>(buildWhen: (previous, state) {
      if (state is UpdateNutrientsState) {
        return false;
      }
      return true;
    }, builder: (context, state) {
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
                    () {
                      snackbar.removeSnackbar();
                      bloc!.add(RemoveFood(false));
                      _showFoodDetails(context, bloc, food);
                    },
                    () {
                      bloc!.add(TempRemoveFoodEvent(food));
                      snackbar.showSnackbar('Food removed', 'Undo', () {
                        bloc.add(RetainFoodListEvent(index, food));
                      }, () {
                        bloc.add(RemoveFood(false));
                      });
                    }
                  ];
                  modal.bottomSheet(context, titles, actions);
                },
              );
            });
      }

      return Container();
    });
  }

  void _retainData(BuildContext context, MealFoodListBloc? bloc) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final retainMealNutrients = arguments['mealNutrients'] as MealNutrients?;
    if (retainMealNutrients != null) {
      bloc!.add(SetupFoodListEvent(retainMealNutrients));
      bloc.date = retainMealNutrients.date;
    }
  }

  void _showFoodDetails(BuildContext context, MealFoodListBloc? bloc, Food food) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => FoodDetailsScreen(food, bloc!.mealNutrients),
            settings: RouteSettings(name: Routes.foodDetailsScreen)))
        .then((val) {
      _retainData(context, bloc);
    });
  }
}
