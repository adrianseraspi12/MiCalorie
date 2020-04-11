import 'package:chopper/chopper.dart';

part 'nutrionx_service.chopper.dart';

@ChopperApi(baseUrl: "/search")
abstract class NutritionxSearchService extends ChopperService {

  static NutritionxSearchService create([ChopperClient client]) => _$NutritionxSearchService(client);

  @Get(path: "/instant")
  Future<Response> getListOfSearchFood(@Query('query') String food, @Query('detailed') bool isShowDetails);

}