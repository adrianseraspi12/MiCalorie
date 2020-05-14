import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';

import 'bloc.dart';

class QuickAddFoodBloc implements Bloc {

  final _resultController = PublishSubject<QuickAddResult>();

  Stream<QuickAddResult> get resultStream => _resultController.stream;

  void addFood(
    String name, 
    String brand, 
    String quantity, 
    String calories, 
    String carbs,
    String fat,
    String protein) {

    print('NAME = $name');

    if (name.isEmpty) {
      _resultController.sink.add(QuickAddResult(
        result: Result.onFailed, 
        errorMessage: 'Name should not be empty')
      );
      return;
    }

    if (quantity.isEmpty || quantity == '0') {
      _resultController.sink.add(QuickAddResult(
        result: Result.onFailed, 
        errorMessage: 'Quantity should be more than 0')
      );
      return;
    }

    if (calories.isEmpty || calories == '0') {
      _resultController.sink.add(QuickAddResult(
        result: Result.onFailed, 
        errorMessage: 'Calories should be more than 0')
      );
      return;
    }

  }

  @override
  void dispose() {

  }

}

class QuickAddResult {

  Result result;
  String errorMessage;

  QuickAddResult({Key key, this.result, this.errorMessage});

}

enum Result {

  onSuccess,
  onFailed

}