import 'package:calorie_counter/bloc/quick_add_food_bloc.dart';
import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/widgets/circular_button.dart';
import 'package:calorie_counter/ui/widgets/neumorphic_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuickAddFoodScreen extends StatelessWidget {

  NeumorphicTextfield _nameTextfield;
  NeumorphicTextfield _brandTextfield;
  NeumorphicTextfield _quantityTextfield;
  NeumorphicTextfield _calorieTextfield;
  NeumorphicTextfield _carbsTextfield;
  NeumorphicTextfield _fatTextfield;
  NeumorphicTextfield _proteinTextfield;

  final MealNutrients _mealNutrients;

  QuickAddFoodScreen(this._mealNutrients);

  @override
  Widget build(BuildContext context) {
    final bloc = QuickAddFoodBloc();
    _setupBloc(bloc);

    bloc.resultStream.listen((event) {
      final result = event.result;

      switch (result) {

        case Result.onSuccess:
          Fluttertoast.showToast(
            msg: 'Food added',
            timeInSecForIosWeb: 2)
            .then((val) => Navigator.popUntil(
              context,
              (route) {
                if (route.settings.name == '/mealFoodListScreen') {
                  (route.settings.arguments as Map) ['mealNutrients'] = _mealNutrients;
                  return true;
                }
                return false;
              }
            )
          );
          break;
        case Result.onFailed:
          _showAlertDialog(context, 'Error', '${event.errorMessage}');
          break;
      }

    });

    return Scaffold(
      backgroundColor: Color.fromRGBO(193,214,233, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildActionButtons(context, bloc),
            Expanded(
              child: _buildTextfields(bloc)
            )
          ],
        )
      ),
    );
  }

  void _setupBloc(QuickAddFoodBloc bloc) async {
    bloc.setupRepository();
  }


  Widget _buildActionButtons(BuildContext context, QuickAddFoodBloc bloc) {
    return Neumorphic(
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
            onPressed: () { Navigator.pop(context); },
          ),

          CircularButton(
            icon: Icon(Icons.add),
            onPressed: () {
              bloc.addFood(
                _mealNutrients,
                _nameTextfield.text, 
                _brandTextfield.text, 
                _quantityTextfield.text,
                _calorieTextfield.text, 
                _carbsTextfield.text, 
                _fatTextfield.text, 
                _proteinTextfield.text
              );
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
            textfield: _nameTextfield = _buildNeumorphicTextfield(
              textHint: 'Food'
            ),
          ),

          _buildTextfield(
            title: 'Brand :', 
            textfield: _brandTextfield = _buildNeumorphicTextfield(
              textHint: '(Optional)'
            ),
          ),

          _buildTextfield(
            title: 'Quantity :', 
            textfield: _quantityTextfield = _buildNeumorphicTextfield(
              text: '1', 
              textInputFormatter: <TextInputFormatter> [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              textInputType: TextInputType.number
            )
          ),

          _buildTextfield(
            title: 'Calories :', 
            textfield: _calorieTextfield = _buildNeumorphicTextfield(
              text: '0', 
              textInputFormatter: <TextInputFormatter> [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              textInputType: TextInputType.number,
            ),
          ),

          _buildTextfield(
            title: 'Carbs :', 
            textfield: _carbsTextfield = _buildNeumorphicTextfield(
              text: '0', 
              textInputFormatter: <TextInputFormatter> [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              textInputType: TextInputType.number
            ),
          ),

          _buildTextfield(
            title: 'Fat :', 
            textfield: _fatTextfield = _buildNeumorphicTextfield(
              text: '0', 
              textInputFormatter: <TextInputFormatter> [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              textInputType: TextInputType.number
            ),
          ),

          _buildTextfield(
            title: 'Protein :', 
            textfield: _proteinTextfield = _buildNeumorphicTextfield(
              text: '0',
              textInputFormatter: <TextInputFormatter> [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              textInputType: TextInputType.number
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildTextfield({
    Key key,
    NeumorphicTextfield textfield,
    String title, 
    Function(String) onChanged,
    Function(String) onEditingComplete,
  }) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )
              ),
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
        textInputAction:  TextInputAction.done,
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