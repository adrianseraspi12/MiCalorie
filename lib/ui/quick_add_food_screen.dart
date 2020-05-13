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

          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: NeumorphicTextfield(
              textInputAction: TextInputAction.done,
              padding: EdgeInsets.all(8.0),
              decoration: InputDecoration(
                hintText: 'Food',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Name :',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: NeumorphicTextfield(
              textInputAction: TextInputAction.done,
              padding: EdgeInsets.all(8.0),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '(Optional)',
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Brand :',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: NeumorphicTextfield(
              text: '1',
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              padding: EdgeInsets.all(8.0),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Quantity :',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: NeumorphicTextfield(
              text: '0',
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              padding: EdgeInsets.all(8.0),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Calories :',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: NeumorphicTextfield(
              text: '0',
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              padding: EdgeInsets.all(8.0),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Carbs :',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: NeumorphicTextfield(
              text: '0',
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,            
              padding: EdgeInsets.all(8.0),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Fat :',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: NeumorphicTextfield(
              text: '0',
              textInputType: TextInputType.numberWithOptions(signed: true, decimal: false),
              textInputAction: TextInputAction.done,
              padding: EdgeInsets.all(8.0),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Protein :',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

}