// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edaman_search_food_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$EdamanSearchFoodService extends EdamanSearchFoodService {
  _$EdamanSearchFoodService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = EdamanSearchFoodService;

  @override
  Future<Response<dynamic>> getListOfSearchFood(
      String? appId, String? appKey, String food) {
    final $url = '/parser';
    final $params = <String, dynamic>{
      'app_id': appId,
      'app_key': appKey,
      'ingr': food
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getBarcodedFood(
      String? appId, String? appKey, String upc) {
    final $url = '/parser';
    final $params = <String, dynamic>{
      'app_id': appId,
      'app_key': appKey,
      'upc': upc
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}
