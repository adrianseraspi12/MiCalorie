import 'package:calorie_counter/data/local/data_source/main_data_source.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/screens/quick_add_food/bloc/quick_add_food_bloc.dart';
import 'package:calorie_counter/ui/screens/quick_add_food/ui/quick_add_food_content.dart';
import 'package:calorie_counter/ui/widgets/neumorphic/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class QuickAddFoodScreen extends StatelessWidget {
  final MealNutrients _mealNutrients;

  QuickAddFoodScreen(this._mealNutrients);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            QuickAddFoodBloc(_mealNutrients, RepositoryProvider.of<MainDataSource>(context)),
        child: Scaffold(
          backgroundColor: Color.fromRGBO(193, 214, 233, 1),
          body: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[QuickAddFoodAppBar(), QuickAddFoodContent()],
          )),
        ));
  }
}

class QuickAddFoodAppBar extends StatelessWidget {
  const QuickAddFoodAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Navigator.pop(context);
            },
          ),
          CircularButton(
            icon: Icon(Icons.add),
            onPressed: () {
              context.read<QuickAddFoodBloc>().add(AddFoodEvent());
            },
          ),
        ],
      ),
    );
  }
}
