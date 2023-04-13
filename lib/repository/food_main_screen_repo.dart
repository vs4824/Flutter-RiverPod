import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_examples/model_class/food_mainpage_models/category_model.dart';
import '../model_class/food_mainpage_models/cuisine_list_model.dart';
import '../model_class/food_mainpage_models/food_category_model.dart';
import '../model_class/food_mainpage_models/food_offers_model.dart';
import '../model_class/food_mainpage_models/restaurant_list_model.dart';

final foodHomePageAPIProvider = Provider<FoodHomePageAPIService>((ref) => FoodHomePageAPIService());

class FoodHomePageAPIService {

  static Future fetchCategory({required String id}) async {
    String url = "http://3.110.75.42:3009/api/v1/customer/home/category-list?storetypeId=$id&lat=28.616316264001956&lng=77.37723708175879";

    var response = await http.get(Uri.parse(url),headers: {
      "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
      "deviceType": "iOS",
      "timezone": "Asia/Kolkata",
      "language": "en",
      "currentVersion": "16.2",
      "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk"
    });

    try {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        final result =  json.decode(response.body);
        final List list = result["data"]["categegoryItems"];
        return  list.map((e) => CategoryModel.fromJson(e)).toList();
      }
    } on HttpException {
      rethrow;
    }
  }

  static Future fetchOffers() async {
    const String url = "http://3.110.75.42:3009/api/v1/customer/offer/offer-list?lat=28.616316264001956&lng=77.37723708175879&storeTypeId=634407b7d43a01c935398589&type=Home";

    var response = await http.get(Uri.parse(url),headers: {
      "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
      "deviceType": "iOS",
      "timezone": "Asia/Kolkata",
      "language": "en",
      "currentVersion": "16.2",
      "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk"
    });

    try {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        final result =  json.decode(response.body);
        final List list = result["data"]["offer"];
        return  list.map((e) => FoodOffersModel.fromJson(e)).toList();
      }
    } on HttpException {
      rethrow;
    }
  }

  static Future fetchCuisineList({required id}) async {
    String url = "http://3.110.75.42:3009/api/v1/customer/content/cuisinee-list?storeTypeId=$id";

    var response = await http.get(Uri.parse(url),headers: {
      "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
      "deviceType": "iOS",
      "timezone": "Asia/Kolkata",
      "language": "en",
      "currentVersion": "16.2",
      "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk"
    });

    try {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        final result =  json.decode(response.body);
        final List list = result["data"]["cuisineeList"];
        return  list.map((e) => CuisineListModel.fromJson(e)).toList();
      }
    } on HttpException {
      rethrow;
    }
  }

  static Future fetchFoodCategoryList() async {
    const String url = "http://3.110.75.42:3009/api/v1/customer/content/foodCategory-list";

    var response = await http.get(Uri.parse(url),headers: {
      "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
      "deviceType": "iOS",
      "timezone": "Asia/Kolkata",
      "language": "en",
      "currentVersion": "16.2",
      "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk"
    });

    try {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        final result =  json.decode(response.body);
        final List list = result["data"]["foodCategoryList"];
        return  list.map((e) => FoodCategoryListModel.fromJson(e)).toList();
      }
    } on HttpException {
      rethrow;
    }
  }

  static Future fetchRestaurantList({required id}) async {
    String url = "http://3.110.75.42:3009/api/v1/customer/home/get-restaurant?lat=28.616316264001956&lng=77.37723708175879&storeTypeId=$id&page=1&perPage=10";

    var response = await http.get(Uri.parse(url),headers: {
      "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
      "deviceType": "iOS",
      "timezone": "Asia/Kolkata",
      "language": "en",
      "currentVersion": "16.2",
      "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk"
    });

    try {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        final result =  json.decode(response.body);
        final List list = result["data"]["categegoryItems"];
        return  list.map((e) => RestaurantListModel.fromJson(e)).toList();
      }
    } on HttpException {
      rethrow;
    }
  }
}