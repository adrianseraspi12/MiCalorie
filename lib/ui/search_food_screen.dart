import 'package:calorie_counter/data/api/model/client_food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/search_food_query_bloc.dart';

import 'food_details_screen.dart';

class SearchFoodScreen extends StatefulWidget {
  
  final MealNutrients mealNutrients;
  SearchFoodScreen(this.mealNutrients);
  
  @override
  _SearchFoodScreenState createState() => _SearchFoodScreenState();

}

class _SearchFoodScreenState extends State<SearchFoodScreen> with SingleTickerProviderStateMixin {

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = SearchFoodQueryBloc();
    bloc.setUpClient();

    return BlocProvider<SearchFoodQueryBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                  textInputAction: TextInputAction.search,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Food',
                    labelStyle: TextStyle(color: Colors.black),
                    suffixIcon: Icon(Icons.search, color: Colors.black),
                  ),
                  onEditingComplete: () {
                    final query = _textEditingController.text;
                    bloc.submitQuery(query);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ),
            ),

        ),
        body: _buildCommonFoodResults(bloc),

      ),
    );
  }

  Widget _buildCommonFoodResults(SearchFoodQueryBloc bloc) {
    return StreamBuilder<SearchResult>(
      stream: bloc.commonFoodStream,
      builder: (context, snapshot) {

        final results = snapshot.data;

        if (results == null) {
          return Center(child: Text('Search A Food'));
        }

        if (results.listOfFood == null) {
          return Center(child: Text('${results.errorMessage}'));
        }

        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(), 
          itemCount: results.listOfFood.length,
          itemBuilder: (context, index) {

            final commonFood = results.listOfFood[index];
            var brandName = commonFood.details.brand ?? 'common';
        
            return ListTile(
              title: Text(commonFood.details.name),
              subtitle: Text(brandName),
              onTap: () {
                // final food = ClientFood(name: commonFood.foodName,
                //                   numberOfServings: commonFood.servingQty,
                //                   servingSize: commonFood.servingUnit,
                //                   nutrients: commonFood.nutrients);
                
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) => FoodDetailsScreen(food, widget.mealNutrients),
                //     settings: RouteSettings(name: Routes.foodDetailsScreen))
                // );
              },
            );

        },
        );
      });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

}