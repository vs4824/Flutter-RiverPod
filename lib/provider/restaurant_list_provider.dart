import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model_class/food_mainpage_models/restaurant_list_model.dart';
import '../repository/restaurant_list_repo.dart';

final fetchListNotifierProvider = StateNotifierProvider<FetchListNotifier, List<RestaurantListModel>>((ref){
  RestaurantListRepoService service = ref.read(restaurantListAPIProvider);
  final ID = ref.watch(fetchListIdProvider);
  return FetchListNotifier(service,ID);
});


final fetchListIdProvider = StateProvider<String>((ref)=> "");


class FetchListNotifier extends StateNotifier<List<RestaurantListModel>> {
  FetchListNotifier(this.service,this.id) : super([]) {
    getCategory(id);
  }
  final RestaurantListRepoService service;
  final String id;

  void getCategory(id) async {
    state = await RestaurantListRepoService.fetchList(id: id);
  }
}