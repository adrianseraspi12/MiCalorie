import 'package:flutter/material.dart';

class Modal{

  bottomSheet(BuildContext context, List<String> titles, List<Function> actions) {
    

    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Material(
          color: Color.fromRGBO(193,214,233, 1),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(titles.length, (index) {
                  return _createTile(context, titles[index], actions[index]);
                }
              )
            ),
          ),
        );

      }
    );
  }

  ListTile _createTile(BuildContext context, String title, Function action) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

}