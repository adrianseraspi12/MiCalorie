import 'package:chopper/chopper.dart';

part 'edaman_search_food_service.chopper.dart';

@ChopperApi(baseUrl: "/parser")
abstract class EdamanSearchFoodService extends ChopperService {

  static EdamanSearchFoodService create([ChopperClient client]) => _$EdamanSearchFoodService(client);

  @Get()
  Future<Response> getListOfSearchFood(@Query('app_id') String appId,
                                        @Query('app_key') String appKey,
                                        @Query('ingr') String food);

  @Get()
  Future<Response> getBarcodedFood(@Query('app_id') String appId,
                                    @Query('app_key') String appKey,
                                    @Query('upc') String upc);

}