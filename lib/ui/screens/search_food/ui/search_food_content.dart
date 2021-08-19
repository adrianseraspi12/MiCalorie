import 'package:calorie_counter/data/api/model/list_of_food.dart';
import 'package:calorie_counter/data/local/entity/food.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/screens/food_details/ui/food_details_screen.dart';
import 'package:calorie_counter/ui/screens/search_food/bloc/search_food_bloc.dart';
import 'package:calorie_counter/ui/widgets/image_view.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:calorie_counter/util/extension/ext_number_rounding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SearchFoodContent extends StatelessWidget {
  const SearchFoodContent({Key? key, required this.mealNutrients}) : super(key: key);
  final MealNutrients mealNutrients;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SearchFoodBloc, SearchFoodState>(
        builder: (context, state) {
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
        },
      ),
    );
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
