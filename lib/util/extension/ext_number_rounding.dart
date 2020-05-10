extension NumberRounding on double {

  double roundTo(int number) {

    if (this == null) {
      return 0;
    }

    return double.parse((this).toStringAsFixed(number));
  } 

}