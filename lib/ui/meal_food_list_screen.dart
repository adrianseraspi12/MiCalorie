import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/meal_food_list_bloc.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/search_food_screen.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/util/extension/ext_meal_type_description.dart';

class MealFoodListScreen extends StatefulWidget {

  MealNutrients mealNutrients;
  MealFoodListScreen(this.mealNutrients);

  @override
  _MealFoodListScreenState createState() => _MealFoodListScreenState();
}

class _MealFoodListScreenState extends State<MealFoodListScreen> {

  @override
  Widget build(BuildContext context) {
    final bloc = MealFoodListBloc(widget.mealNutrients.id); 
    _setupRepository(bloc);

    return BlocProvider<MealFoodListBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left), 
            onPressed: () {
              Navigator.pop(context, this.widget.mealNutrients.date);
            }),
          title: Text('${widget.mealNutrients.type.description()} Food List'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white ,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchFoodScreen(widget.mealNutrients),
                    settings: RouteSettings(name: Routes.searchFoodScreen)
                  )
                ).then((v) {
                    _retainData(context, bloc);
                });
              })
          ],
        ),
        body: _buildResult(bloc),
      ),
    );
  }

  Widget _buildResult(MealFoodListBloc bloc) {
    return StreamBuilder<List<Food>>(
      stream: bloc.foodListStream,
      builder: (context, snapshot) {

        final listOfFood = snapshot.data;

        if (listOfFood == null || listOfFood.length == 0) {
          return Center(child: Text('NO FOODS'),);
        }
        else {
          return ListView.separated(
            itemCount: listOfFood.length,
            separatorBuilder: (context, index) => Divider(), 
            itemBuilder: (context, index) {

              final food = listOfFood[index];

              return ListTile(
                title: Text('${food.name}'),
                subtitle: Text('${food.servingSize}'),
                trailing: Text('${food.numOfServings}'),
              );

            });
        }

      },
    );
  }

  void _setupRepository(MealFoodListBloc bloc) async {
    bloc.setupRepository();
  }

  void _retainData(BuildContext context, MealFoodListBloc bloc) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    final mealNutrients = arguments['mealNutrients'];
    
    if (mealNutrients != null) {
      widget.mealNutrients = mealNutrients;
      bloc.setupFoodList();
    }
    
   }
}