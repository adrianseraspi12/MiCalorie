import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/daily_summary_bloc.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/entity/total_nutrients_per_day.dart';
import 'package:calorie_counter/util/extension/ext_meal_type_description.dart';
import 'package:calorie_counter/ui/meal_food_list_screen.dart';
import 'package:calorie_counter/util/constant/routes.dart';
import 'package:flutter/material.dart';

class DailySummaryScreen extends StatefulWidget {
  
  @override
  _DailySummaryScreenState createState() => _DailySummaryScreenState();
}

class _DailySummaryScreenState extends State<DailySummaryScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final bloc = DailySummaryBloc();
    _setupData(bloc);

    return BlocProvider<DailySummaryBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: _buildAppBarDate(context, bloc),
        ),
        body: _buildResult(bloc)
      ),
    );
  }

  void _setupData(DailySummaryBloc bloc) async {
    bloc.setupRepository();
  }

  Widget _buildAppBarDate(BuildContext context, DailySummaryBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.dateTimeStream,
      builder: (context, snapshot) {

        var date = snapshot.data;

        if (date == null) {
          date = 'Today';
        }

        return Container(
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
              '$date',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white)
              ),

              Icon(
                Icons.keyboard_arrow_down, 
                color: Colors.white,
              ),

            ]),
            onPressed: () {
              _buildDatePicker(context, bloc);
            },
          ),
        );
      }
    );
  }

  void _buildDatePicker(BuildContext context, DailySummaryBloc bloc) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate, 
      firstDate: DateTime(1920), 
      lastDate: DateTime(2120));

    if (pickedDate != null) {
      selectedDate = pickedDate;
      bloc.updateTimeAndTotalNutrients(pickedDate);
    }

  }

  Widget _buildResult(DailySummaryBloc bloc) {
    return StreamBuilder<DailySummaryResult>(
      stream: bloc.dailySummaryResultStream,
      builder: (context, snapshot) {

        final dailySummaryResult = snapshot.data;

        if (dailySummaryResult == null) {
          return Center(child: Text('DATA UNAVAILABLE'));
        }
        else {
          return ListView.builder(
            itemCount: dailySummaryResult.mealNutrients.length + 1,
            itemBuilder: (context, index) {

              if (index == 0) {
                return _buildTotalNutrients(dailySummaryResult.totalNutrientsPerDay);
              }

              index -= 1;

              var mealNutrients = dailySummaryResult.mealNutrients[index];

              return _buildMealSummary(context, bloc, mealNutrients);

            });
        }

      });
  }

  Widget _buildTotalNutrients(TotalNutrientsPerDay totalNutrients) {
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

  Widget _buildMealSummary(BuildContext context, DailySummaryBloc bloc, MealNutrients mealNutrients) {
    return Material(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: InkWell(
          onTap: () {
            _showMealFoodListScreen(context, mealNutrients, bloc);
          },
          child: Container(
            child: Column(
              
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${mealNutrients.type.description()}',
                        style: TextStyle(fontSize: 32.0)),
                      
                      Text(
                        '${mealNutrients.calories}',
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
                              '${mealNutrients.carbs}',
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
                              '${mealNutrients.fat}',
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
                              '${mealNutrients.protein}',
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
        ),

      ),
    );
  }

  void _showMealFoodListScreen(BuildContext context, MealNutrients mealNutrients, DailySummaryBloc bloc) async {
    var date = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealFoodListScreen(mealNutrients),
        settings: RouteSettings(name: Routes.mealFoodListScreen,
                                arguments: Map())
      )
    );
    bloc.changeTotalNutrients(date);
  }

}