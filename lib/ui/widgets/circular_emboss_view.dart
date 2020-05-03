import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CircularEmbossView extends StatelessWidget {
  
  final Widget child;

  CircularEmbossView({Key key, this.child}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: EdgeInsets.all(24.0),
      boxShape: NeumorphicBoxShape.circle(),
      style: NeumorphicStyle(
        depth: -15,
        shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
        shadowLightColorEmboss: Colors.white,
        color: Color.fromRGBO(193,214,233, 1),
      ),
      child: child
    );
  }

}