// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edaman_search_food_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$EdamanSearchFoodService extends EdamanSearchFoodService {
  _$EdamanSearchFoodService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = EdamanSearchFoodService;

  Future<Response> getListOfSearchFood(
      String appId, String appKey, String food) {
    final $url = '/parser';
    final Map<String, dynamic> $params = {
      'app_id': appId,
      'app_key': appKey,
      'ingr': food
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getBarcodedFood(String appId, String appKey, String upc) {
    final $url = '/parser';
    final Map<String, dynamic> $params = {
      'app_id': appId,
      'app_key': appKey,
      'upc': upc
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}
