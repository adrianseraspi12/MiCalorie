extension NumberRounding on double {

  double roundTo(int number) {
    return double.parse((this).toStringAsFixed(2));
  } 

}