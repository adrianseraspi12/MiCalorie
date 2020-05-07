import 'package:flutter/material.dart';

class Modal{

  bottomSheet(BuildContext context, List<IconData> icons, List<String> titles, List<Function> actions) {
    

    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Material(
          color: Color.fromRGBO(193,214,233, 1),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(icons.length, (index) {
                  return _createTile(context, titles[index], icons[index], actions[index]);
                }
              )
            ),
          ),
        );

      }
    );
  }

  ListTile _createTile(BuildContext context, String title, IconData icon, Function action) {
    return ListTile(
      leading: Icon(icon),
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