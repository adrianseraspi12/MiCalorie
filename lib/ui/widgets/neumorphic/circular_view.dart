import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CircularView extends StatelessWidget {
  
  final Widget child;

  CircularView({Key key, this.child}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: EdgeInsets.all(24.0),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        shadowLightColor: Colors.white,
        shadowDarkColor: Color.fromRGBO(163,177,198, 1),
        color: Color.fromRGBO(193,214,233, 1),
      ),
      child: child
    );
  }

}