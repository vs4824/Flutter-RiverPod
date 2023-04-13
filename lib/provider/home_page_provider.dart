import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model_class/homepage_models/check_order_progress_model.dart';
import '../model_class/homepage_models/food_category_model.dart';
import '../model_class/homepage_models/mainpage_offers_model.dart';
import '../repository/homepage_repo.dart';

final categoryNotifierProvider = StateNotifierProvider<HomePageNotifier, List<FoodCategoryModel>>((ref){
  HomePageAPIService service = ref.read(homePageAPIProvider);
  return HomePageNotifier(service);
});

final offersNotifierProvider = StateNotifierProvider<OffersNotifier, List<MainPageOffersModel>>((ref){
  HomePageAPIService service = ref.read(homePageAPIProvider);
  return OffersNotifier(service);
});

final orderProgressNotifierProvider = StateNotifierProvider<OrderProgressNotifier, List<CheckOrderProgressModel>>((ref){
  HomePageAPIService service = ref.read(homePageAPIProvider);
  return OrderProgressNotifier(service);
});



class HomePageNotifier extends StateNotifier<List<FoodCategoryModel>> {
  HomePageNotifier(this.service) : super([]) {
    getCategory();
  }
  final HomePageAPIService service;

  void getCategory() async {
    state = await HomePageAPIService.foodCategory();
  }
}

class OffersNotifier extends StateNotifier<List<MainPageOffersModel>> {
  OffersNotifier(this.service) : super([]) {
    getOffers();
  }
  final HomePageAPIService service;

  void getOffers() async {
    state = await HomePageAPIService.offers();
  }
}

class OrderProgressNotifier extends StateNotifier<List<CheckOrderProgressModel>> {
  OrderProgressNotifier(this.service) : super([]) {
    getOrderProgressUrl();
  }
  final HomePageAPIService service;

  void getOrderProgressUrl() async {
    state = await HomePageAPIService.checkOrderProgressUrl();
  }
}