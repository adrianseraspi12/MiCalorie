import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CircularButton extends StatefulWidget {
  Icon icon;
  Function onPressed;

  CircularButton({Key key, this.icon, this.onPressed}) : super(key: key);

  @override
  _CircularButtonState createState() => _CircularButtonState();
}

class _CircularButtonState extends State<CircularButton> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      child: widget.icon,
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        shape: NeumorphicShape.convex,
        shadowDarkColorEmboss: Color.fromRGBO(163, 177, 198, 1),
        shadowLightColorEmboss: Colors.white,
        color: Color.fromRGBO(193, 214, 233, 1),
      ),
      onPressed: widget.onPressed,
    );
  }
}
