import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_examples/model_class/homepage_models/check_order_progress_model.dart';
import 'package:riverpod_examples/model_class/homepage_models/mainpage_offers_model.dart';
import '../model_class/homepage_models/food_category_model.dart';

final homePageAPIProvider = Provider<HomePageAPIService>((ref) => HomePageAPIService());

class HomePageAPIService {

  static Future foodCategory() async {
    const String url = "http://3.110.75.42:3009/api/v1/customer/home/storeType-list?search=";

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
        final result =  json.decode(response.body);
        final List list = result["data"]["items"];
      return  list.map((e) => FoodCategoryModel.fromJson(e)).toList();

      }
    } on HttpException {
      rethrow;
    }
  }

  static Future offers() async {
    const String url = "http://3.110.75.42:3009/api/v1/customer/offer/offer-list?lat=28.616316264001956&lng=77.37723708175879&type=Home";

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
        final result =  json.decode(response.body);
        final List list = result["data"]["offer"];
        return  list.map((e) => MainPageOffersModel.fromJson(e)).toList();
      }
    } on HttpException {
      rethrow;
    }
  }

  static Future checkOrderProgressUrl() async {
    const String url = "http://3.110.75.42:3009/api/v1/customer/order/checkOrder";

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
        if (kDebugMode) {
          print(json.decode(response.body));
        }
        final result =  json.decode(response.body);
        final List list = result["data"];
        return  list.map((e) => CheckOrderProgressModel.fromJson(e)).toList();
      }
    } on HttpException {
      rethrow;
    }
  }
}