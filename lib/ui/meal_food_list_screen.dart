import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/meal_food_list_bloc.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/search_food_screen.dart';
import 'package:calorie_counter/ui/widgets/circular_button.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/util/extension/ext_meal_type_description.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
        backgroundColor: Color.fromRGBO(193,214,233, 1),
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: Icon(Icons.chevron_left), 
        //     onPressed: () {
        //       Navigator.pop(context, this.widget.mealNutrients.date);
        //     }),
        //   title: Text('${widget.mealNutrients.type.description()} Food List'),
        //   actions: <Widget>[
        //     IconButton(
        //       icon: Icon(Icons.add),
        //       color: Colors.white ,
        //       onPressed: () {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (context) => SearchFoodScreen(widget.mealNutrients),
        //             settings: RouteSettings(name: Routes.searchFoodScreen)
        //           )
        //         ).then((v) {
        //             _retainData(context, bloc);
        //         });
        //       })
        //   ],
        // ),
        body: _buildMealFoodListScreen(context, bloc),
      ),
    );
  }

  Widget _buildMealFoodListScreen(BuildContext context, MealFoodListBloc bloc) {
    return SafeArea(
      child: Column(
        children: <Widget> [
          _buildAppbar(context, bloc),
          Expanded(
            child: _buildResult(bloc)
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
            onPressed: () => Navigator.pop(context),
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchFoodScreen(widget.mealNutrients),
                  settings: RouteSettings(name: Routes.searchFoodScreen)
                )
              ).then((v) {
                  _retainData(context, bloc);
              });
            },
          ),

        ],
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
          return ListView.builder(
            itemCount: listOfFood.length, 
            itemBuilder: (context, index) {

              final food = listOfFood[index];

              return NeumorphicButton(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                onClick: () {

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

  void _retainData(BuildContext context, MealFoodListBloc bloc) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    final mealNutrients = arguments['mealNutrients'];
    
    if (mealNutrients != null) {
      widget.mealNutrients = mealNutrients;
      bloc.setupFoodList();
    }
    
   }
}