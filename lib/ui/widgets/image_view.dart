import 'package:calorie_counter/ui/widgets/svg_loader.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  ImageView({Key key, this.resourceName, this.height, this.width, this.caption = ""});

  final String resourceName;
  final int height;
  final int width;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: SvgLoader.load(resourceName, height, width)),
          _buildCaption()
        ],
      ),
    );
  }

  Widget _buildCaption() {
    if (caption.isEmpty) {
      return Container();
    }
    return Text(
      caption,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
