// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrionx_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$NutritionxSearchService extends NutritionxSearchService {
  _$NutritionxSearchService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = NutritionxSearchService;

  Future<Response> getListOfSearchFood(String food, bool isShowDetails) {
    final $url = '/search/instant';
    final Map<String, dynamic> $params = {
      'query': food,
      'detailed': isShowDetails
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}
