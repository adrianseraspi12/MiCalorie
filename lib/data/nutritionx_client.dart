import 'package:calorie_counter/data/nutrionx_service.dart';
import 'package:chopper/chopper.dart';

class NutritionxClient {

  NutritionxSearchService searchService;

  NutritionxClient() {
    final chopper = ChopperClient(
      baseUrl: ' https://trackapi.nutritionix.com/v2',
      services: [
        //  Inject here the service
        NutritionxSearchService.create()
      ]
    );

    //  retrieve the injected service
    searchService = chopper.getService<NutritionxSearchService>();
  }

  void searchFood(String food) async {
    final response = await searchService.getListOfSearchFood(food, true);

    if (response.isSuccessful) {
      //  successful request
      final body = response.body;
      print("BODY = $body");
    }
    else {
      // error from server
      final code = response.statusCode;
      print("CODE = $code");
    }
  }

}