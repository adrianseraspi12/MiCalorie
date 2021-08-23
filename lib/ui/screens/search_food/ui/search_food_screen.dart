import 'package:calorie_counter/data/api/client/edaman_client.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/screens/search_food/bloc/search_food_bloc.dart';
import 'package:calorie_counter/ui/screens/search_food/ui/search_food_content.dart';
import 'package:calorie_counter/ui/widgets/neumorphic/circular_button.dart';
import 'package:calorie_counter/ui/widgets/neumorphic/neumorphic_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SearchFoodScreen extends StatelessWidget {
  final MealNutrients mealNutrients;

  SearchFoodScreen(this.mealNutrients);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchFoodBloc(RepositoryProvider.of<EdamanClient>(context)),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(193, 214, 233, 1),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [SearchFoodAppBar(), SearchFoodContent(mealNutrients: mealNutrients)],
        )),
      ),
    );
  }
}

class SearchFoodAppBar extends StatelessWidget {
  const SearchFoodAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildSearchScreen(context);
  }

  Widget _buildSearchScreen(BuildContext context) {
    return Neumorphic(
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
              context.read<SearchFoodBloc>().add(SearchFoodQueryEvent(query));
            },
          ))
        ],
      ),
    );
  }
}
