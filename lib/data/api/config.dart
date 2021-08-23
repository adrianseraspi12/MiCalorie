import 'client/edaman_search_food_service.dart';

class Config {
  String? appId;
  String? appKey;
  EdamanSearchFoodService searchService;

  Config(this.appId, this.appKey, this.searchService);
}
