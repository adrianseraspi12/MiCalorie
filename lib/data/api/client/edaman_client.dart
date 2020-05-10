import 'package:calorie_counter/config/app_config.dart';
import 'package:calorie_counter/data/api/client/edaman_search_food_service.dart';
import 'package:calorie_counter/data/api/interceptor/connection_interceptor.dart';
import 'package:calorie_counter/data/api/model/list_of_food.dart';
import 'package:chopper/chopper.dart';

class EdamanClient {

  EdamanSearchFoodService searchService;
  
  String appId;
  String appKey;

  EdamanClient();

  Future<ResponseResult<ListOfFood>> searchFood(String food) async {
    final response = await searchService.getListOfSearchFood(appId, appKey, food);

    if (response.isSuccessful) {
      //  successful request
      final body = response.body;
      final listOfFood = ListOfFood.fromJson(body);
      return ResponseResult<ListOfFood>(listOfFood, null);
    }
    else {
      // error from server
      final code = response.statusCode;
      print('Code = $code');
      
      return ResponseResult<ListOfFood>(null, 'Something unexpected happened');
    }
  }

  Future<ResponseResult<ListOfFood>> searchBarcode(String upc) async {
    final response = await searchService.getBarcodedFood(appId, appKey, upc);

    if (response.isSuccessful) {
      //  successful request
      final body = response.body;
      final listOfFood = ListOfFood.fromJson(body);
      return ResponseResult<ListOfFood>(listOfFood, null);
    }
    else {
      // error from server
      final code = response.statusCode;

      return ResponseResult<ListOfFood>(null, 'Something unexpected happened');
    }
  }

  Future setUpClient() async {

    try {
      final appConfig = await AppConfig.forCredentials();
      appId = appConfig.appId;
      appKey = appConfig.appKey;
    }
    catch (err) {
      print('Caught an error: $err');
    }

    final chopper = ChopperClient(
      baseUrl: 'https://api.edamam.com/api/food-database',
      converter: JsonConverter(),
      interceptors: [
        HttpLoggingInterceptor(),
        ConnectionInterceptor()
      ],
      services: [
        //  Inject here the service
        EdamanSearchFoodService.create()
      ]
    );

    //  retrieve the injected service
    searchService = chopper.getService<EdamanSearchFoodService>();
  }

}

class ResponseResult<T> {

  T data;
  String errorMessage;

  ResponseResult(this.data, this.errorMessage);

}