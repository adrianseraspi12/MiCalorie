import 'package:calorie_counter/data/local/entity/meal_nutrients.dart';
import 'package:calorie_counter/ui/screens/quick_add_food/bloc/quick_add_food_bloc.dart';
import 'package:calorie_counter/ui/screens/quick_add_food/bloc/quick_add_food_text_field_type.dart';
import 'package:calorie_counter/ui/widgets/neumorphic/neumorphic_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuickAddFoodContent extends StatelessWidget {
  const QuickAddFoodContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuickAddFoodBloc, QuickAddFoodState>(
        listenWhen: (previous, state) {
          if (state is LoadingQuickAddFoodState || state is LoadedQuickAddFoodState) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          if (state is LoadingQuickAddFoodState) {
            _showAlertDialog(context, 'SAVING', 'LOADING...');
          } else if (state is LoadedQuickAddFoodState) {
            _showToast(context, state.mealNutrients);
          } else if (state is ErrorQuickAddFoodState) {
            _showAlertDialog(context, 'Error', '${state.message}');
          }
        },
        child: Expanded(child: _buildTextfields(context)));
  }

  Widget _buildTextfields(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildTextfield(
            title: 'Name :',
            textfield: _buildNeumorphicTextfield(
                textHint: 'Food',
                onChanged: (text) {
                  context.read<QuickAddFoodBloc>().updateText(text, QuickAddFoodTextFieldType.name);
                }),
          ),
          _buildTextfield(
            title: 'Brand :',
            textfield: _buildNeumorphicTextfield(
                textHint: '(Optional)',
                onChanged: (text) {
                  context
                      .read<QuickAddFoodBloc>()
                      .updateText(text, QuickAddFoodTextFieldType.brand);
                }),
          ),
          _buildTextfield(
            title: 'Quantity :',
            textfield: _buildNeumorphicTextfield(
                text: '1',
                textInputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                textInputType: TextInputType.number,
                onChanged: (text) {
                  context
                      .read<QuickAddFoodBloc>()
                      .updateText(text, QuickAddFoodTextFieldType.quantity);
                }),
          ),
          _buildTextfield(
            title: 'Calories :',
            textfield: _buildNeumorphicTextfield(
                text: '0',
                textInputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                textInputType: TextInputType.number,
                onChanged: (text) {
                  context
                      .read<QuickAddFoodBloc>()
                      .updateText(text, QuickAddFoodTextFieldType.calories);
                }),
          ),
          _buildTextfield(
            title: 'Carbs :',
            textfield: _buildNeumorphicTextfield(
                text: '0',
                textInputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                textInputType: TextInputType.number,
                onChanged: (text) {
                  context
                      .read<QuickAddFoodBloc>()
                      .updateText(text, QuickAddFoodTextFieldType.carbs);
                }),
          ),
          _buildTextfield(
            title: 'Fat :',
            textfield: _buildNeumorphicTextfield(
                text: '0',
                textInputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                textInputType: TextInputType.number,
                onChanged: (text) {
                  context.read<QuickAddFoodBloc>().updateText(text, QuickAddFoodTextFieldType.fat);
                }),
          ),
          _buildTextfield(
            title: 'Protein :',
            textfield: _buildNeumorphicTextfield(
                text: '0',
                textInputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                textInputType: TextInputType.number,
                onChanged: (text) {
                  context
                      .read<QuickAddFoodBloc>()
                      .updateText(text, QuickAddFoodTextFieldType.protein);
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildTextfield({
    required NeumorphicTextfield textfield,
    required String title,
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
    String text = '',
    String? textHint,
    TextInputType? textInputType,
    List<TextInputFormatter>? textInputFormatter,
    Function(String)? onChanged,
    Function(String)? onEditingComplete,
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

  void _showAlertDialog(BuildContext context, String title, String content) {
    Widget okButton = TextButton(
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

  void _showToast(BuildContext context, MealNutrients mealNutrients) {
    Fluttertoast.showToast(msg: 'Food added', timeInSecForIosWeb: 2)
        .then((val) => Navigator.popUntil(context, (route) {
              if (route.settings.name == '/mealFoodListScreen') {
                (route.settings.arguments as Map)['mealNutrients'] = mealNutrients;
                return true;
              }
              return false;
            }));
  }
}
