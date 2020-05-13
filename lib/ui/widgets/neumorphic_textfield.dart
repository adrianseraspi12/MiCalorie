import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicTextfield extends StatefulWidget {
  
  final InputDecoration decoration;
  final Function(String) onEditingComplete;
  final Function onChanged;
  final Function onTap;
  final Widget leading;
  final EdgeInsets padding;
  final String text;
  final TextInputAction textInputAction;
  final TextInputType textInputType;

  NeumorphicTextfield({
    Key key,
    this.leading, 
    this.decoration, 
    this.padding = const EdgeInsets.all(0), 
    this.text = '',
    this.textInputAction,
    this.textInputType,
    this.onEditingComplete, 
    this.onChanged, 
    this.onTap}): super(key:key);
  
  @override
  _NeumorphicTextfieldState createState() => _NeumorphicTextfieldState();
}

class _NeumorphicTextfieldState extends State<NeumorphicTextfield> {
  TextEditingController _textEditingController;
  double _textfieldDepth = 5;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: this.widget.text);

    if (this.widget.text.isEmpty) {
      if (_textfieldDepth.toInt() != 5) {
          _textfieldDepth = 5;
      }
    }
    else {
      _textfieldDepth = -5;
    }

  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      child: Neumorphic(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        boxShape: NeumorphicBoxShape.roundRect(borderRadius: BorderRadius.circular(4.0)),
        style: NeumorphicStyle(
          depth: _textfieldDepth,
          shadowDarkColorEmboss: Color.fromRGBO(163,177,198, 1),
          shadowLightColorEmboss: Colors.white,
          color: Color.fromRGBO(193,214,233, 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            this.widget.leading == null ? Container() : this.widget.leading,

            Expanded(
              child: Container(
                padding: this.widget.padding,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Focus(
                  onFocusChange: (hasFocus) {

                    if (!hasFocus) {
                      final text = _textEditingController.text;
                      if (text == null || text.isEmpty) {
                        if (_textfieldDepth.toInt() != 5) {
                          setState(() {
                            _textfieldDepth = 5;
                          });
                        }
                      }
                    }

                  },
                  child: TextFormField(
                    keyboardType: this.widget.textInputType,
                    textAlign: TextAlign.left,
                    textInputAction: this.widget.textInputAction,
                    controller: _textEditingController,
                    decoration: this.widget.decoration,
                    onTap: () {

                      if (this.widget.onTap != null) {
                        this.widget.onTap();
                      }

                      if (_textfieldDepth.toInt() != -5) {
                        setState(() {
                          _textfieldDepth = -5;
                        });
                      }
                    },

                    onChanged: (string) {

                      if (this.widget.onChanged != null) {
                        this.widget.onChanged();
                      }

                      if (_textfieldDepth.toInt() != -5) {
                        setState(() {
                          _textfieldDepth = -5;
                        });
                      }
                    },
                    onEditingComplete: () {
                      final text = _textEditingController.text;
                      if (text == null || text.isEmpty) {
                        if (_textfieldDepth.toInt() != 5) {
                          setState(() {
                            _textfieldDepth = 5;
                          });
                        }
                      }

                      if (this.widget.onEditingComplete != null) {
                        this.widget.onEditingComplete(text);
                      }

                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

}