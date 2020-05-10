extension NumberRounding on double {

  int roundTo(int number) {

    if (this == null) {
      return 0;
    }

    return double.parse((this).toStringAsFixed(number)).toInt();
  } 

}