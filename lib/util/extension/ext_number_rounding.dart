extension NumberRounding on double {

  int roundTo(int number) {
    return double.parse((this).toStringAsFixed(number)).toInt();
  } 

}