import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/meal_food_list_bloc.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/model/meal_summary.dart';
import 'package:calorie_counter/ui/routes.dart';
import 'package:calorie_counter/ui/search_food_screen.dart';
import 'package:flutter/material.dart';

class MealFoodListScreen extends StatefulWidget {

  MealSummary mealSummary;
  MealFoodListScreen(this.mealSummary);

  @override
  _MealFoodListScreenState createState() => _MealFoodListScreenState();
}

class _MealFoodListScreenState extends State<MealFoodListScreen> {

  @override
  Widget build(BuildContext context) {
    final bloc = MealFoodListBloc(widget.mealSummary.id); 
    _setupRepository(bloc);

    return BlocProvider<MealFoodListBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.mealSummary.name} Food List'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white ,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchFoodScreen(widget.mealSummary),
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
    this.widget.mealSummary = arguments['mealSummary'];
    bloc.setupFoodList();
   }
}