import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model_class/restaurants_models/fetch_offers_model.dart';
import '../model_class/restaurants_models/veg_option_list_model.dart';
import '../repository/restaurant_repo.dart';

final fetchOffersNotifierProvider = StateNotifierProvider<FetchOffersNotifier, List<FetchOffers>>((ref){
  RestaurantRepoService service = ref.read(restaurantAPIProvider);
  final ID = ref.watch(idProvider);
  return FetchOffersNotifier(service,ID);
});

final fetchVegOptionListNotifierProvider = StateNotifierProvider<FetchVegOptionListNotifier, List<VegOptionList>>((ref){
  RestaurantRepoService service = ref.read(restaurantAPIProvider);
  return FetchVegOptionListNotifier(service);
});

final fetchMenuItemsNotifierProvider = StateNotifierProvider<FetchMenuItemsNotifier, Map<String,dynamic>>((ref){
  RestaurantRepoService service = ref.read(restaurantAPIProvider);
  final id = ref.watch(idsProvider);
  final veg_nonveg = ref.watch(vegNonVegIdProvider);
  return FetchMenuItemsNotifier(service,id,veg_nonveg);
});


final idProvider = StateProvider<String>((ref)=> "");


class FetchOffersNotifier extends StateNotifier<List<FetchOffers>> {
  FetchOffersNotifier(this.service,this.id) : super([]) {
    getCategory(id);
  }
  final RestaurantRepoService service;
  final String id;

  void getCategory(id) async {
    state = await RestaurantRepoService.fetchOffers(id: id);
  }
}

class FetchVegOptionListNotifier extends StateNotifier<List<VegOptionList>> {
  FetchVegOptionListNotifier(this.service) : super([]) {
    getOffers();
  }
  final RestaurantRepoService service;

  void getOffers() async {
    state = await RestaurantRepoService.fetchVegOptionList();
  }
}

final idsProvider = StateProvider<String>((ref)=> ref.toString());

final vegNonVegIdProvider = StateProvider<String>((ref)=> ref.toString());

class FetchMenuItemsNotifier extends StateNotifier<Map<String, dynamic>> {
  FetchMenuItemsNotifier(this.service,this.id,this.veg_nonveg) : super({}) {
    getOrderProgressUrl(id, veg_nonveg);
  }
  final RestaurantRepoService service;
  final String id;
  final String veg_nonveg;

  void getOrderProgressUrl(id,vegNonvegId) async {
    state = await RestaurantRepoService.fetchMenuItems(id: id, veg_nonveg_id: veg_nonveg);
  }
}