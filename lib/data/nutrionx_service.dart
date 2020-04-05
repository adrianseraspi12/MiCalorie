import 'package:chopper/chopper.dart';

@ChopperApi(baseUrl: "/search")
abstract class NutritionxSearchService extends ChopperService {

  static NutritionxSearchService create([ChopperClient client]) => _NutritionxSearchService(client);

  @Get(path: "instant/{detailed}/{query}")
  Future<Response> getListOfSearchFood(@Path('query') String food, @Path('detailed') bool isShowDetails);

}