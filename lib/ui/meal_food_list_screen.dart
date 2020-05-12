import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/meal_food_list_bloc.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/search_food_screen.dart';
import 'package:calorie_counter/ui/widgets/circular_button.dart';
import 'package:calorie_counter/ui/widgets/modal.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/util/extension/ext_meal_type_description.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';

import 'food_details_screen.dart';

class MealFoodListScreen extends StatefulWidget {

  MealNutrients mealNutrients;
  MealFoodListScreen(this.mealNutrients);

  @override
  _MealFoodListScreenState createState() => _MealFoodListScreenState();
}

class _MealFoodListScreenState extends State<MealFoodListScreen> {
  final modal = Modal();
  SnackBar snackbar;

  @override
  Widget build(BuildContext context) {
    final bloc = MealFoodListBloc(widget.mealNutrients.id); 
    _setupRepository(bloc);

    return BlocProvider<MealFoodListBloc>(
      bloc: bloc,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(193,214,233, 1),
        body: Builder(
          builder: (rootContext) => _buildMealFoodListScreen(rootContext, bloc),)
      ),
    );
  }

  Widget _buildMealFoodListScreen(BuildContext context, MealFoodListBloc bloc) {
    bloc.updateNutrientsOnPopStream.listen((isPop) {

      if (isPop) {
        _removeSnackbar(context, bloc);
        Navigator.pop(context, widget.mealNutrients.date);
      }
    });

    return SafeArea(
      child: Column(
        children: <Widget> [
          _buildAppbar(context, bloc),
          Expanded(
            child: _buildResult(context, bloc)
          )
        ]
      )
    );
    
  }

  Widget _buildAppbar(BuildContext context, MealFoodListBloc bloc) {
    return Neumorphic(
      margin: EdgeInsets.only(bottom: 4.0),
      padding: EdgeInsets.all(16.0),
      style: NeumorphicStyle(
        shadowLightColor: Color.fromRGBO(193,214,233, 1),
        color: Color.fromRGBO(193,214,233, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CircularButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              bloc.removeFoodOnPop();
             },
          ),

          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 8.0),
                child: FittedBox(
                  child: Text(
                    '${widget.mealNutrients.type.description()}',
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
                  _removeSnackbar(context, bloc);
                }, 
                () {

                  _removeSnackbar(context, bloc)
                    .then((_) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchFoodScreen(widget.mealNutrients),
                          settings: RouteSettings(name: Routes.searchFoodScreen)
                        )
                      ).then((v) {
                          _retainData(context, bloc);
                      });
                    }
                  );

                }
              ];

              modal.bottomSheet(context, titles, actions);
            },
          ),

        ],
      ),
    );
  }

  Widget _buildResult(BuildContext rootContext, MealFoodListBloc bloc) {
    return StreamBuilder<List<Food>>(
      stream: bloc.foodListStream,
      builder: (context, snapshot) {

        final listOfFood = snapshot.data;

        if (listOfFood == null || listOfFood.length == 0) {
          final assetName = 'assets/images/signs.svg';
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: _loadSVGImage(assetName, 100, 100)
                ),
                Text(
                  'No saved foods',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          );
        }
        else {
          return ListView.builder(
            itemCount: listOfFood.length, 
            itemBuilder: (context, index) {

              final food = listOfFood[index];
              return NeumorphicButton(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                onClick: () {
                  final titles = ['View Food', 'Remove Food'];
                  final actions = [
                    () {
                      _removeSnackbar(context, bloc);
                      _showFoodDetails(context, bloc, food);
                    }, 
                    () {
                      _showSnackbar(rootContext, bloc, food, index);
                    }
                  ];
                  modal.bottomSheet(rootContext, titles, actions);
                },              
                style: NeumorphicStyle(
                  depth: 2,
                  shadowLightColor: Colors.white,
                  shadowDarkColor: Color.fromRGBO(163,177,198, 1),
                  color: Color.fromRGBO(193,214,233, 1),
                ),
                child: ListTile(
                  title: Text('${food.name}'),
                  subtitle: Text('${food.brandName}'),
                  trailing: Text('${food.numOfServings}'),
                ),
              );

            }
          );
        }

      },
    );
  }

  void _setupRepository(MealFoodListBloc bloc) async {
    bloc.setupRepository();
  }

  void _showSnackbar(BuildContext context, MealFoodListBloc bloc, Food food, int index) {
    _removeSnackbar(context, bloc)
      .then((_) {
        snackbar = SnackBar(
          content: Text('Food removed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              bloc.retainFoodList(index, food);
            }
          ),
        );

        Scaffold.of(context).showSnackBar(snackbar)
          .closed
          .then((reason) {
            if (reason == SnackBarClosedReason.dismiss ||
                reason == SnackBarClosedReason.hide ||
                reason == SnackBarClosedReason.swipe ||
                reason == SnackBarClosedReason.timeout) {

              bloc.removeFood();
            }
          }
        );

        bloc.tempRemoveFood(food);
      }
    );

  }

  void _showFoodDetails(BuildContext context, MealFoodListBloc bloc, Food food) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => FoodDetailsScreen(food, widget.mealNutrients),
        settings: RouteSettings(name: Routes.foodDetailsScreen)
      )
    ).then((val) {
      _retainData(context, bloc);
    });

  }

  Future<void> _removeSnackbar(BuildContext context, MealFoodListBloc bloc) async {
    if (snackbar != null) {
      bloc.removeFood();
      Scaffold.of(context).removeCurrentSnackBar();
    }
  }

  void _retainData(BuildContext context, MealFoodListBloc bloc) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    final mealNutrients = arguments['mealNutrients'];
    
    if (mealNutrients != null) {
      widget.mealNutrients = mealNutrients;
      bloc.setupFoodList();
    }
    
   }

    Widget _loadSVGImage(String assetName, int height, int width) {
    return SizedBox(
      height: 100,
      width: 100,
      child: SvgPicture.asset(
        assetName,
      ),
    );
  }
  
}