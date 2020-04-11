import 'dart:convert';

import 'package:calorie_counter/config/app_config.dart';
import 'package:calorie_counter/data/model/list_of_food.dart';
import 'package:calorie_counter/data/nutrionx_service.dart';
import 'package:chopper/chopper.dart';

class NutritionxClient {

  NutritionxSearchService searchService;

  NutritionxClient();

  Future<ListOfFood> searchFood(String food) async {
    final response = await searchService.getListOfSearchFood(food, true);

    if (response.isSuccessful) {
      //  successful request
      final body = response.body;
      return ListOfFood.fromJson(body);
    }
    else {
      // error from server
      final code = response.statusCode;
    }
  }

  Future setUpClient() async {
    String appId;
    String appKey;

    try {
      final appConfig = await AppConfig.forCredentials();
      appId = appConfig.appId;
      appKey = appConfig.appKey;
    }
    catch (err) {
      print('Caught an error: $err');
    }

    final chopper = ChopperClient(
      baseUrl: 'https://trackapi.nutritionix.com/v2',
      converter: JsonConverter(),
      interceptors: [
        HeadersInterceptor({'x-app-id': appId, 'x-app-key': appKey}),
        HttpLoggingInterceptor()
      ],
      services: [
        //  Inject here the service
        NutritionxSearchService.create()
      ]
    );

    //  retrieve the injected service
    searchService = chopper.getService<NutritionxSearchService>();
  }

}