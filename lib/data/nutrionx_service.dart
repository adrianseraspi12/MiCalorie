import 'package:chopper/chopper.dart';

@ChopperApi(baseUrl: "/search")
abstract class NutritionxSearchService extends ChopperService {

  static NutritionxSearchService create([ChopperClient client]) => _$NutritionxSearchService(client);

}