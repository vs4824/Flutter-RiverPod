import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model_class/food_mainpage_models/category_model.dart';
import '../model_class/food_mainpage_models/cuisine_list_model.dart';
import '../model_class/food_mainpage_models/food_category_model.dart';
import '../model_class/food_mainpage_models/food_offers_model.dart';
import '../model_class/food_mainpage_models/restaurant_list_model.dart';
import '../repository/food_main_screen_repo.dart';


final foodCategoryNotifierProvider = StateNotifierProvider<FoodCategoryNotifier, List<CategoryModel>>((ref){
  FoodHomePageAPIService service = ref.read(foodHomePageAPIProvider);
  final id = ref.watch(fetchIdProvider);
  return FoodCategoryNotifier(service,id);
});

final foodOffersNotifierProvider = StateNotifierProvider<FoodOffersNotifier, List<FoodOffersModel>>((ref){
  FoodHomePageAPIService service = ref.read(foodHomePageAPIProvider);
  return FoodOffersNotifier(service);
});

final cuisineNotifierProvider = StateNotifierProvider<CuisineNotifier, List<CuisineListModel>>((ref){
  FoodHomePageAPIService service = ref.read(foodHomePageAPIProvider);
  final id = ref.watch(fetchIdProvider);
  return CuisineNotifier(service,id);
});

final restaurantNotifierProvider = StateNotifierProvider<RestaurantNotifier, List<FoodCategoryListModel>>((ref){
  FoodHomePageAPIService service = ref.read(foodHomePageAPIProvider);
  return RestaurantNotifier(service);
});

final foodCategoryInRestaurantListNotifierProvider = StateNotifierProvider<FoodCategoryInRestaurantListNotifier, List<RestaurantListModel>>((ref){
  FoodHomePageAPIService service = ref.read(foodHomePageAPIProvider);
  final id = ref.watch(fetchIdProvider);
  return FoodCategoryInRestaurantListNotifier(service,id);
});



final fetchIdProvider = StateProvider<String>((ref)=> "");


class FoodCategoryNotifier extends StateNotifier<List<CategoryModel>> {
  FoodCategoryNotifier(this.service,this.id) : super([]) {
    getCategory(id);
  }
  final FoodHomePageAPIService service;
  final String id;

  void getCategory(String id) async {
    state = await FoodHomePageAPIService.fetchCategory(id: id);
  }
}

class FoodOffersNotifier extends StateNotifier<List<FoodOffersModel>> {
  FoodOffersNotifier(this.service) : super([]) {
    getOffers();
  }
  final FoodHomePageAPIService service;

  void getOffers() async {
    state = await FoodHomePageAPIService.fetchOffers();
  }
}

class CuisineNotifier extends StateNotifier<List<CuisineListModel>> {
  CuisineNotifier(this.service,this.id) : super([]) {
    getOffers(id);
  }
  final FoodHomePageAPIService service;
  final String id;

  void getOffers(id) async {
    state = await FoodHomePageAPIService.fetchCuisineList(id: id);
  }
}

class RestaurantNotifier extends StateNotifier<List<FoodCategoryListModel>> {
  RestaurantNotifier(this.service) : super([]) {
    getOffers();
  }
  final FoodHomePageAPIService service;

  void getOffers() async {
    state = await FoodHomePageAPIService.fetchFoodCategoryList();
  }
}

class FoodCategoryInRestaurantListNotifier extends StateNotifier<List<RestaurantListModel>> {
  FoodCategoryInRestaurantListNotifier(this.service,this.id) : super([]) {
    getOffers(id);
  }
  final FoodHomePageAPIService service;
  final String id;

  void getOffers(id) async {
    state = await FoodHomePageAPIService.fetchRestaurantList(id: id);
  }
}
