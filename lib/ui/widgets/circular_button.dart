import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CircularButton extends StatelessWidget {

  Icon icon;
  Function onPressed;

  CircularButton({Key key, this.icon, this.onPressed}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
        boxShape: NeumorphicBoxShape.circle(),
        child: icon,
        style: NeumorphicStyle(
        shape: NeumorphicShape.convex,
        shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
        shadowLightColorEmboss: Colors.white,
        color: Color.fromRGBO(193,214,233, 1),
      ),
      onClick: onPressed,
    );
  }
}