import 'package:calorie_counter/bloc/quick_add_food/quick_add_food_bloc.dart';
import 'package:calorie_counter/bloc/quick_add_food/quick_add_food_text_field_type.dart';
import 'package:calorie_counter/data/local/app_database.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/data/local/repository/food_repository.dart';
import 'package:calorie_counter/data/local/repository/meal_nutrients_repository.dart';
import 'package:calorie_counter/data/local/repository/total_nutrients_per_day_repository.dart';
import 'package:calorie_counter/ui/widgets/circular_button.dart';
import 'package:calorie_counter/ui/widgets/neumorphic_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuickAddFoodScreen extends StatelessWidget {
  final MealNutrients _mealNutrients;

  QuickAddFoodScreen(this._mealNutrients);

  @override
  Widget build(BuildContext context) {
    QuickAddFoodBloc quickAddFoodBloc;
    return FutureBuilder<AppDatabase>(
        future: AppDatabase.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Container();
          }
          final database = snapshot.data;
          quickAddFoodBloc = QuickAddFoodBloc(
              MealNutrientsRepository(database.mealNutrientsDao),
              FoodRepository(database.foodDao),
              TotalNutrientsPerDayRepository(database.totalNutrientsPerDayDao),
              _mealNutrients);
          return BlocProvider<QuickAddFoodBloc>(
            create: (context) => quickAddFoodBloc,
            child: BlocListener<QuickAddFoodBloc, QuickAddFoodState>(
              listenWhen: (previous, state) {
                if (state is LoadingQuickAddFoodState ||
                    state is LoadedQuickAddFoodState) {
                  return true;
                }
                return false;
              },
              listener: (context, state) {
                if (state is LoadingQuickAddFoodState) {
                  _showAlertDialog(context, 'SAVING', 'LOADING...');
                } else if (state is LoadedQuickAddFoodState) {
                  Fluttertoast.showToast(
                          msg: 'Food added', timeInSecForIosWeb: 2)
                      .then((val) => Navigator.popUntil(context, (route) {
                            if (route.settings.name == '/mealFoodListScreen') {
                              (route.settings.arguments
                                      as Map)['mealNutrients'] =
                                  state.mealNutrients;
                              return true;
                            }
                            return false;
                          }));
                } else if (state is ErrorQuickAddFoodState) {
                  _showAlertDialog(context, 'Error', '${state.message}');
                }
              },
              child: Scaffold(
                backgroundColor: Color.fromRGBO(193, 214, 233, 1),
                body: SafeArea(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildActionButtons(context, quickAddFoodBloc),
                    Expanded(child: _buildTextfields(quickAddFoodBloc))
                  ],
                )),
              ),
            ),
          );
        });
  }

  Widget _buildActionButtons(BuildContext context, QuickAddFoodBloc bloc) {
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CircularButton(
            icon: Icon(Icons.add),
            onPressed: () {
              bloc.add(AddFoodEvent());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextfields(QuickAddFoodBloc bloc) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildTextfield(
            title: 'Name :',
            textfield: _buildNeumorphicTextfield(
                textHint: 'Food',
                onChanged: (text) {
                  bloc.updateText(text, QuickAddFoodTextFieldType.name);
                }),
          ),
          _buildTextfield(
            title: 'Brand :',
            textfield: _buildNeumorphicTextfield(
                textHint: '(Optional)',
                onChanged: (text) {
                  bloc.updateText(text, QuickAddFoodTextFieldType.brand);
                }),
          ),
          _buildTextfield(
            title: 'Quantity :',
            textfield: _buildNeumorphicTextfield(
                text: '1',
                textInputFormatter: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                textInputType: TextInputType.number,
                onChanged: (text) {
                  bloc.updateText(text, QuickAddFoodTextFieldType.quantity);
                }),
          ),
          _buildTextfield(
            title: 'Calories :',
            textfield: _buildNeumorphicTextfield(
                text: '0',
                textInputFormatter: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                textInputType: TextInputType.number,
                onChanged: (text) {
                  bloc.updateText(text, QuickAddFoodTextFieldType.calories);
                }),
          ),
          _buildTextfield(
            title: 'Carbs :',
            textfield: _buildNeumorphicTextfield(
                text: '0',
                textInputFormatter: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                textInputType: TextInputType.number,
                onChanged: (text) {
                  bloc.updateText(text, QuickAddFoodTextFieldType.carbs);
                }),
          ),
          _buildTextfield(
            title: 'Fat :',
            textfield: _buildNeumorphicTextfield(
                text: '0',
                textInputFormatter: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                textInputType: TextInputType.number,
                onChanged: (text) {
                  bloc.updateText(text, QuickAddFoodTextFieldType.fat);
                }),
          ),
          _buildTextfield(
            title: 'Protein :',
            textfield: _buildNeumorphicTextfield(
                text: '0',
                textInputFormatter: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                textInputType: TextInputType.number,
                onChanged: (text) {
                  bloc.updateText(text, QuickAddFoodTextFieldType.protein);
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildTextfield({
    Key key,
    NeumorphicTextfield textfield,
    String title,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              child: Text(title,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ),
          Expanded(
            flex: 8,
            child: textfield,
          ),
        ],
      ),
    );
  }

  NeumorphicTextfield _buildNeumorphicTextfield({
    Key key,
    String text = '',
    String textHint,
    TextInputType textInputType,
    List<TextInputFormatter> textInputFormatter,
    Function(String) onChanged,
    Function(String) onEditingComplete,
  }) {
    return NeumorphicTextfield(
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      text: text,
      textInputAction: TextInputAction.done,
      textInputType: textInputType,
      textInputFormatter: textInputFormatter,
      padding: EdgeInsets.all(8.0),
      decoration: InputDecoration(
        hintText: textHint,
        border: InputBorder.none,
        hintStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  _showAlertDialog(BuildContext context, String title, String content) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
