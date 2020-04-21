import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/meal_food_list_bloc.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/model/meal_summary.dart';
import 'package:flutter/material.dart';

class MealFoodListScreen extends StatelessWidget {

  final MealSummary mealSummary;
  const MealFoodListScreen({Key key, this.mealSummary}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = MealFoodListBloc(mealSummary.id); 
    setupRepository(bloc);

    return BlocProvider<MealFoodListBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${mealSummary.name} Food List'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white ,
              onPressed: () {})
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

        if (listOfFood == null) {
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

  void setupRepository(MealFoodListBloc bloc) async {
    //  repository here
    bloc.setupRepository();
  }

}