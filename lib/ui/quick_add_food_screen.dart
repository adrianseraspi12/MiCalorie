import 'package:calorie_counter/ui/widgets/circular_button.dart';
import 'package:calorie_counter/ui/widgets/neumorphic_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class QuickAddFoodScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color.fromRGBO(193,214,233, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildActionButtons(context),
            Expanded(
              child: _buildTextfields()
            )
          ],
        )
      ),
    );
  }


  Widget _buildActionButtons(BuildContext context) {
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTextfields() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          _buildTextfield(
            title: 'Name :', 
            textHint: 'Food'
          ),

          _buildTextfield(
            title: 'Brand :', 
            textHint: '(Optional)'
          ),

          _buildTextfield(
            title: 'Quantity :', 
            text: '1', 
            textInputType: TextInputType.number,
            onChanged: (quantity) {
              //  add bloc here to compute quantity
            },
            onEditingComplete: (quantity) {
              //  add bloc here to compute quantity
            }
          ),

          _buildTextfield(
            title: 'Calories :', 
            text: '0', 
            textInputType: TextInputType.number
          ),

          _buildTextfield(
            title: 'Carbs :', 
            text: '0', 
            textInputType: TextInputType.number
          ),

          _buildTextfield(
            title: 'Fat :', 
            text: '0', 
            textInputType: TextInputType.number
          ),

          _buildTextfield(
            title: 'Protein :', 
            text: '0', 
            textInputType: TextInputType.number
          ),

        ],
      ),
    );
  }

  Widget _buildTextfield({
    Key key,
    String title, 
    String text = '', 
    TextInputType textInputType,
    String textHint,
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
            child: NeumorphicTextfield(
              onChanged: onChanged,
              onEditingComplete: onEditingComplete,
              text: text,
              textInputAction:  TextInputAction.done,
              textInputType: textInputType,
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
            ),
          ),
        ],
      ),
    );
  }

}