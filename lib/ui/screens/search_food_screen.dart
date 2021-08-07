import 'package:calorie_counter/bloc/search_food/search_food_bloc.dart';
import 'package:calorie_counter/data/api/client/edaman_client.dart';
import 'package:calorie_counter/data/api/config.dart';
import 'package:calorie_counter/data/api/model/list_of_food.dart';
import 'package:calorie_counter/data/api/service.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/screens/food_details/ui/food_details_screen.dart';
import 'package:calorie_counter/ui/widgets/image_view.dart';
import 'package:calorie_counter/ui/widgets/neumorphic/circular_button.dart';
import 'package:calorie_counter/ui/widgets/neumorphic/neumorphic_textfield.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:calorie_counter/util/extension/ext_number_rounding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SearchFoodScreen extends StatelessWidget {
  final MealNutrients mealNutrients;

  SearchFoodScreen(this.mealNutrients);

  @override
  Widget build(BuildContext context) {
    SearchFoodBloc searchFoodBloc;
    return FutureBuilder<Config>(
        future: Service.setUpClientConfig(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Container();
          }
          var config = snapshot.data;
          searchFoodBloc = SearchFoodBloc(EdamanClient(config));
          return BlocProvider<SearchFoodBloc>(
            create: (context) => searchFoodBloc,
            child: Scaffold(
              backgroundColor: Color.fromRGBO(193, 214, 233, 1),
              body: SafeArea(child: _buildSearchScreen(context, searchFoodBloc)),
            ),
          );
        });
  }

  Widget _buildSearchScreen(BuildContext context, SearchFoodBloc bloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Neumorphic(
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
                  bloc.add(SearchFoodQueryEvent(query));
                },
              ))
            ],
          ),
        ),
        Expanded(child: _buildCommonFoodResult(bloc))
      ],
    );
  }

  Widget _buildCommonFoodResult(SearchFoodBloc searchFoodBloc) {
    return BlocBuilder<SearchFoodBloc, SearchFoodState>(builder: (context, state) {
      if (state is InitialSearchFoodState) {
        return _buildEmptyUI('Search now');
      } else if (state is LoadingSearchFoodState) {
        return Center(child: CircularProgressIndicator(color: Colors.white));
      } else if (state is ErrorSearchFoodState) {
        return _buildEmptyUI(state.errorMessage);
      } else if (state is LoadedSearchFoodState) {
        return _buildList(state.listOfFood!);
      }
      return Container();
    });
  }

  Widget _buildEmptyUI(String? message) {
    final String assetName = 'assets/images/search.svg';
    return ImageView(
      resourceName: assetName,
      height: 100,
      width: 100,
      caption: message,
    );
  }

  Widget _buildList(List<CommonFood> listOfCommonFood) {
    return ListView.builder(
        itemCount: listOfCommonFood.length,
        itemBuilder: (context, index) {
          final commonFood = listOfCommonFood[index];
          var brandName = commonFood.details!.brand ?? 'Generic';

          return NeumorphicButton(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            onPressed: () {
              final food = Food(
                  -1,
                  mealNutrients.id,
                  commonFood.details!.name,
                  1,
                  brandName,
                  commonFood.details!.nutrients!.calories.roundTo(0).toInt(),
                  commonFood.details!.nutrients!.carbs.roundTo(0).toInt(),
                  commonFood.details!.nutrients!.fat.roundTo(0).toInt(),
                  commonFood.details!.nutrients!.protein.roundTo(0).toInt());

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => FoodDetailsScreen(food, mealNutrients),
                  settings: RouteSettings(name: Routes.foodDetailsScreen)));
            },
            style: NeumorphicStyle(
              depth: 2,
              shadowLightColor: Colors.white,
              shadowDarkColor: Color.fromRGBO(163, 177, 198, 1),
              color: Color.fromRGBO(193, 214, 233, 1),
            ),
            child: ListTile(
              title: Text(
                commonFood.details!.name!,
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
        });
  }
}
