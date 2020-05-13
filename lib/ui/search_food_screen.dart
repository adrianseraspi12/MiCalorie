import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/widgets/circular_button.dart';
import 'package:calorie_counter/ui/widgets/neumorphic_textfield.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/search_food_query_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:calorie_counter/util/extension/ext_number_rounding.dart';

import 'food_details_screen.dart';

class SearchFoodScreen extends StatefulWidget {
  
  final MealNutrients mealNutrients;
  SearchFoodScreen(this.mealNutrients);
  
  @override
  _SearchFoodScreenState createState() => _SearchFoodScreenState();

}

class _SearchFoodScreenState extends State<SearchFoodScreen> with SingleTickerProviderStateMixin {

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
        backgroundColor: Color.fromRGBO(193,214,233, 1),
        body: _buildSearchScreen(context, bloc),
      ),
    );
  }

  Widget _buildSearchScreen(BuildContext context, SearchFoodQueryBloc bloc) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget> [
          Neumorphic(
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
                  child: NeumorphicTextfield(
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Food',
                      suffixIcon: Icon(Icons.search, color: Colors.black),
                      hintStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onEditingComplete: (query) {
                      bloc.submitQuery(query);
                    },
                  )
                )

              ],
            ),
          ),
          
          Expanded(
            child: _buildCommonFoodResults(bloc)
          )
        ],
      ),
    );
    
  }

  Widget _buildCommonFoodResults(SearchFoodQueryBloc bloc) {
    return StreamBuilder<SearchResult>(
      stream: bloc.commonFoodStream,
      builder: (context, snapshot) {

        final results = snapshot.data;
        
        if (results == null) {
          final String assetName = 'assets/images/search.svg';
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: _loadSVGImage(assetName, 100, 100)
                ),
                Text(
                  'Search food now',
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

        if(results.isLoading) {
          return Center(
            child: Loading(
              indicator: BallPulseIndicator(), 
              size: 50.0
            )
          );
        }

        if (results.listOfFood == null) {
          final String assetName = 'assets/images/signs.svg';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: _loadSVGImage(assetName, 100, 100)
                ),
                Text(
                  '${results.errorMessage}',
                  textAlign: TextAlign.center,
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

        return ListView.builder(
          itemCount: results.listOfFood.length,
          itemBuilder: (context, index) {
            final commonFood = results.listOfFood[index];
            var brandName = commonFood.details.brand ?? 'Generic';
        
            return NeumorphicButton(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onClick: () {
                final food = Food(-1, 
                  widget.mealNutrients.id,
                  commonFood.details.name, 
                  1, 
                  brandName, 
                  commonFood.details.nutrients.calories.roundTo(0).toInt(), 
                  commonFood.details.nutrients.carbs.roundTo(0).toInt(), 
                  commonFood.details.nutrients.fat.roundTo(0).toInt(), 
                  commonFood.details.nutrients.protein.roundTo(0).toInt());
                
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => FoodDetailsScreen(food, widget.mealNutrients),
                    settings: RouteSettings(name: Routes.foodDetailsScreen))
                );
              },
              style: NeumorphicStyle(
                depth: 2,
                shadowLightColor: Colors.white,
                shadowDarkColor: Color.fromRGBO(163,177,198, 1),
                color: Color.fromRGBO(193,214,233, 1),
              ),
              child: ListTile(
                title: Text(
                  commonFood.details.name,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                  ),
                ),
                subtitle: Text(
                  brandName,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                  ),  
                ),
              ),
            );
          }
        );

      });
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