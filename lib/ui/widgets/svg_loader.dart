import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgLoader {
  static Widget load(String assetName, int? height, int? width) {
    return SizedBox(
      height: 100,
      width: 100,
      child: SvgPicture.asset(assetName,),
    );
  }
}
