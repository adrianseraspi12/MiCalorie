import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/daily_summary_bloc.dart';
import 'package:calorie_counter/data/local/entity/breakfast_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:flutter/material.dart';

class DailySummaryScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final bloc = DailySummaryBloc();
    setupData(bloc);

    return BlocProvider<DailySummaryBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(title: Text('Daily Summary')),

        body: ListView(
          shrinkWrap: true,
          children: <Widget>[

            _buildTotalNutrients(bloc),
            _buildBreakfast(bloc)

          ],
        )
      ),
    );
  }

  Widget _buildTotalNutrients(DailySummaryBloc bloc) {
    return StreamBuilder<TotalNutrientsPerDay>(
      stream: bloc.totalNutrientsPerDayStream,
      builder: (context, snapshot) {
        final totalNutrients = snapshot.data;
        
        if (totalNutrients == null) {
          return Center(child: Text('DATA UNAVAILABLE'),);
        }
        else {
          return Card(
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Column(children: <Widget>[
                  Text(
                    '${totalNutrients.carbs}',
                    style: TextStyle(fontSize: 32.0),),
                  Text(
                    'Carbs',
                    style: TextStyle(fontSize: 16.0))
                ],),

                Column(children: <Widget>[
                  Text(
                    '${totalNutrients.fat}',
                    style: TextStyle(fontSize: 32.0)),
                  Text(
                    'Fat',
                    style: TextStyle(fontSize: 16.0))
                ],),

                Column(children: <Widget>[
                  Text(
                    '${totalNutrients.protein}',
                    style: TextStyle(fontSize: 32.0)),
                  Text(
                    'Protein',
                    style: TextStyle(fontSize: 16.0))
                ],),

                Column(children: <Widget>[
                  Text(
                    '${totalNutrients.calories}',
                    style: TextStyle(fontSize: 32.0)),
                  Text(
                    'Calories',
                    style: TextStyle(fontSize: 16.0))
                ],),

              ],
            ),),
          );
        }

      },
      );
  }

  Widget _buildBreakfast(DailySummaryBloc bloc) {
    return StreamBuilder<BreakfastNutrients>(
      stream: bloc.breakfastNutrientsStream,
      builder: (context, snapshot) {

        // final breakfastNutrients = snapshot.data;
        final breakfastNutrients = BreakfastNutrients(0, 0, 0, 0, 0);
        
        // if (breakfastNutrients == null) {
        //   return Center(child: Text('DATA UNAVAILABLE'),);
        // }
        // else {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              child: Column(
                
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Breakfast',
                          style: TextStyle(fontSize: 32.0)),
                        
                        Text(
                          '${breakfastNutrients.calories}',
                          style: TextStyle(fontSize: 32.0)),

                      ],
                    ),
                  ),

                  Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        Container(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${breakfastNutrients.carbs}',
                                style: TextStyle(fontSize: 32.0),),
                              Text(
                                'Carbs',
                                style: TextStyle(fontSize: 16.0))
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${breakfastNutrients.fat}',
                                style: TextStyle(fontSize: 32.0),),
                              Text(
                                'Fat',
                                style: TextStyle(fontSize: 16.0))
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${breakfastNutrients.protein}',
                                style: TextStyle(fontSize: 32.0),),
                              Text(
                                'Protein',
                                style: TextStyle(fontSize: 16.0))
                            ],
                          ),
                        ),

                      ],
                        ),

                      Expanded(child: Text('VIEW DETAILS'))

                    ],
                  ),

                ],

              )
            ),

          );

        // }

      },

    );
  }

  void setupData(DailySummaryBloc bloc) async {
    bloc.setupRepository();
  }

}