import 'package:calorie_counter/data/api/model/client_food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/widgets/circular_button.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/search_food_query_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import 'food_details_screen.dart';

class SearchFoodScreen extends StatefulWidget {
  
  final MealNutrients mealNutrients;
  SearchFoodScreen(this.mealNutrients);
  
  @override
  _SearchFoodScreenState createState() => _SearchFoodScreenState();

}

class _SearchFoodScreenState extends State<SearchFoodScreen> with SingleTickerProviderStateMixin {

  TextEditingController _textEditingController = TextEditingController();
  double _textfieldDepth = 5;

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
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    child: Neumorphic(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      boxShape: NeumorphicBoxShape.roundRect(borderRadius: BorderRadius.circular(4.0)),
                      style: NeumorphicStyle(
                        depth: _textfieldDepth,
                        shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
                        shadowLightColorEmboss: Colors.white,
                        color: Color.fromRGBO(193,214,233, 1),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          textInputAction: TextInputAction.search,
                          controller: _textEditingController,
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
                          onTap: () {
                            if (_textfieldDepth.toInt() != -5) {
                              setState(() {
                                _textfieldDepth = -5;
                              });
                            }
                          },
                          onChanged: (string) {
                            if (_textfieldDepth.toInt() != -5) {
                              setState(() {
                                _textfieldDepth = -5;
                              });
                            }
                          },
                          onEditingComplete: () {
                            final query = _textEditingController.text;
                            if (query == null || query.isEmpty) {
                              if (_textfieldDepth.toInt() != 5) {
                                setState(() {
                                  _textfieldDepth = 5;
                                });
                              }
                            }
                            bloc.submitQuery(query);
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        ),
                      ),
                    ),
                  ),
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
          return Center(child: Text('Search A Food'));
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
          return Center(child: Text('${results.errorMessage}'));
        }

        return ListView.builder(
          itemCount: results.listOfFood.length,
          itemBuilder: (context, index) {
            final commonFood = results.listOfFood[index];
            var brandName = commonFood.details.brand ?? 'Generic';
        
            return NeumorphicButton(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              onClick: () {
                final food = ClientFood(name: commonFood.details.name,
                                  numberOfServings: 1,
                                  brand: brandName,
                                  nutrients: commonFood.details.nutrients);
                
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
                title: Text(commonFood.details.name),
                subtitle: Text(brandName),
              ),
            );
          }
        );

      });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

}