import 'package:calorie_counter/data/model/list_of_food.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/search_food_query_bloc.dart';

class SearchFoodScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final bloc = SearchFoodQueryBloc();
    bloc.setUpClient();

    return BlocProvider<SearchFoodQueryBloc>(
      bloc: bloc,
          child: Scaffold(
        appBar: AppBar(title: Text('Food List')),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4)),
                  hintText: 'Search Food'),
                
                onChanged: (query) {
                  bloc.submitQuery(query);
                },
                
              ),
            ),

            Expanded(child: _buildResults(bloc))

          ],

          ),
      ),
    );
  }

  Widget _buildResults(SearchFoodQueryBloc bloc) {
    return StreamBuilder<ListOfFood>(
      stream: bloc.listOfFoodStream,
      builder: (context, snapshot) {

        final results = snapshot.data;

        if (results == null) {
          return Center(child: Text('Search A Food'));
        }

        if (results.commonFood.isEmpty) {
          return Center(child: Text('No Food Found'));
        }

        return _buildSearchResults(results);

      });
  }

  Widget _buildSearchResults(ListOfFood listOfFood) {
    return ListView.separated(
      itemBuilder: (context, index) {

        final commonFood = listOfFood.commonFood[index];
        
        return ListTile(
          title: Text(commonFood.foodName)
        );

      }, 
      separatorBuilder: (BuildContext context, int index) => Divider(), 
      itemCount: listOfFood.brandedFood.length);
  }

}