import 'package:calorie_counter/config/app_config.dart';
import 'package:calorie_counter/data/api/config.dart';
import 'package:chopper/chopper.dart';

import 'client/edaman_search_food_service.dart';
import 'interceptor/connection_interceptor.dart';

class Service {
  static Future<Config> setUpClientConfig() async {
    String? appId = "";
    String? appKey = "";

    try {
      final appConfig = await AppConfig.forCredentials();
      appId = appConfig.appId;
      appKey = appConfig.appKey;
    } catch (err) {
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
        ]);

    var service = chopper.getService<EdamanSearchFoodService>();

    //  retrieve the injected service
    return Config(appId, appKey, service);
  }
}
