import 'package:flutter/material.dart';

class SearchFoodScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food List')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4)),
                hintText: 'Search Food'),
              
              onChanged: (query) {},
              
            ),
          ),

          Expanded(child: _buildResults())

        ],

        ),
    );
  }

  Widget _buildResults() {
    return Center(child: Text('No food is found'));
  }

}