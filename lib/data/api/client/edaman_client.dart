import 'package:calorie_counter/data/api/config.dart';
import 'package:calorie_counter/data/api/model/list_of_food.dart';

class EdamanClient {
  final Config config;

  EdamanClient(this.config);

  Future<ResponseResult<ListOfFood>> searchFood(String food) async {
    final response = await config.searchService
        .getListOfSearchFood(config.appId, config.appKey, food);

    if (response.isSuccessful) {
      //  successful request
      final body = response.body;
      final listOfFood = ListOfFood.fromJson(body);
      return ResponseResult<ListOfFood>(listOfFood, null);
    } else {
      // error from server
      final code = response.statusCode;
      print('Code = $code');

      return ResponseResult<ListOfFood>(null, 'Something unexpected happened');
    }
  }

  Future<ResponseResult<ListOfFood>> searchBarcode(String upc) async {
    final response = await config.searchService
        .getBarcodedFood(config.appId, config.appKey, upc);

    if (response.isSuccessful) {
      //  successful request
      final body = response.body;
      final listOfFood = ListOfFood.fromJson(body);
      return ResponseResult<ListOfFood>(listOfFood, null);
    } else {
      // error from server
      final code = response.statusCode;

      return ResponseResult<ListOfFood>(null, 'Something unexpected happened');
    }
  }
}

class ResponseResult<T> {
  T data;
  String errorMessage;

  ResponseResult(this.data, this.errorMessage);
}
