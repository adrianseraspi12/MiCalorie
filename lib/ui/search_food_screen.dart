import 'package:calorie_counter/data/api/model/client_food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/widgets/circular_button.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/search_food_query_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
        backgroundColor: Color.fromRGBO(193,214,233, 1),
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
        // body: _buildSearchScreen(context, bloc),
      ),
    );
  }

  Widget _buildSearchScreen(BuildContext context, SearchFoodQueryBloc bloc) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        child: Column(
         
          children: <Widget> [
            SizedBox(
              height: height * 0.1,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    CircularButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () => Navigator.pop(context),
                    ),

                    Expanded(
                      child: Container(
                        child: Neumorphic(
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          // padding: EdgeInsets.symmetric(horizontal: 16.0),
                          boxShape: NeumorphicBoxShape.roundRect(borderRadius: BorderRadius.circular(4.0)),
                          style: NeumorphicStyle(
                            depth: -15,
                            shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
                            shadowLightColorEmboss: Colors.white,
                            color: Color.fromRGBO(193,214,233, 1),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.search,
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 1.0)
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
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
                    )

                  ],
                ),
              ),
            )
          ],

        ),
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
            var brandName = commonFood.details.brand ?? 'Generic';
        
            return ListTile(
              title: Text(commonFood.details.name),
              subtitle: Text(brandName),
              onTap: () {
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