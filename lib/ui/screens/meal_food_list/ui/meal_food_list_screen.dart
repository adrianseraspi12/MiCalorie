import 'package:calorie_counter/data/local/data_source/main_data_source.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/screens/meal_food_list/bloc/meal_food_list_bloc.dart';
import 'package:calorie_counter/ui/screens/meal_food_list/ui/meal_food_list_content.dart';
import 'package:calorie_counter/ui/screens/quick_add_food/ui/quick_add_food_screen.dart';
import 'package:calorie_counter/ui/screens/search_food/ui/search_food_screen.dart';
import 'package:calorie_counter/ui/widgets/modal.dart';
import 'package:calorie_counter/ui/widgets/neumorphic/circular_button.dart';
import 'package:calorie_counter/ui/widgets/snackbar.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:calorie_counter/util/extension/ext_meal_type_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MealFoodListScreen extends StatelessWidget {
  final modal = Modal();
  final MealNutrients mealNutrients;

  MealFoodListScreen(this.mealNutrients);

  @override
  Widget build(BuildContext context) {
    Snackbar snackbar = Snackbar(context);
    return BlocProvider(
      create: (context) =>
          MealFoodListBloc(RepositoryProvider.of<MainDataSource>(context), mealNutrients),
      child: WillPopScope(
        onWillPop: () async {
          snackbar.removeSnackbar();
          context.read<MealFoodListBloc>().add(RemoveFood(true));
          return false;
        },
        child: Scaffold(
          backgroundColor: Color.fromRGBO(193, 214, 233, 1),
          body: BlocListener<MealFoodListBloc, MealFoodListState>(
            listenWhen: (previous, current) => current is UpdateNutrientsState,
            listener: (context, state) {
              if (state is UpdateNutrientsState) {
                snackbar.removeSnackbar();
                if (state.isOnPop) {
                  String? date = context.read<MealFoodListBloc>().date;
                  Navigator.pop(context, date);
                }
              }
            },
            child: _buildRoot(context, snackbar),
          ),
        ),
      ),
    );
  }

  Widget _buildRoot(BuildContext context, Snackbar snackbar) {
    return SafeArea(
        child: Column(
      children: [
        _MealFoodListAppBar(mealNutrients: mealNutrients, snackBar: snackbar),
        Expanded(
          child: MealFoodListContent(
              showSnackbar: _showSnackbar(context, snackbar),
              hideSnackbar: () => snackbar.removeSnackbar()),
        )
      ],
    ));
  }

  Function(VoidCallback, VoidCallback) _showSnackbar(BuildContext context, Snackbar snackbar) {
    return (actionCallback, dismissCallback) =>
        snackbar.showSnackbar('Food removed', 'Undo', actionCallback, dismissCallback);
  }
}

class _MealFoodListAppBar extends StatelessWidget {
  const _MealFoodListAppBar({Key? key, required this.mealNutrients, required this.snackBar})
      : super(key: key);

  final MealNutrients mealNutrients;
  final Snackbar snackBar;

  @override
  Widget build(BuildContext context) {
    context.read<MealFoodListBloc>().add(SetupFoodListEvent(mealNutrients));
    return _buildAppBar(context);
  }

  Widget _buildAppBar(BuildContext context) {
    final modal = Modal();
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
              context.read<MealFoodListBloc>().add(RemoveFood(true));
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
              final actions = [_quickAddAction(context), _searchFood(context)];
              modal.bottomSheet(context, titles, actions);
            },
          ),
        ],
      ),
    );
  }

  VoidCallback _quickAddAction(BuildContext context) {
    return () {
      snackBar.removeSnackbar();
      context.read<MealFoodListBloc>().add(RemoveFood(false));

      var route = MaterialPageRoute(
          builder: (newContext) => QuickAddFoodScreen(context.read<MealFoodListBloc>().mealNutrients),
          settings: RouteSettings(name: Routes.quickAddFoodScreen));

      Navigator.of(context).push(route).then((value) => _retainData(context));
    };
  }

  VoidCallback _searchFood(BuildContext context) {
    return () {
      snackBar.removeSnackbar();
      context.read<MealFoodListBloc>().add(RemoveFood(false));

      var route = MaterialPageRoute(
          builder: (newContext) => SearchFoodScreen(mealNutrients),
          settings: RouteSettings(name: Routes.searchFoodScreen));

      Navigator.of(context).push(route).then((v) => _retainData(context));
    };
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
