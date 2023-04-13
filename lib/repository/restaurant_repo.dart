import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model_class/restaurants_models/fetch_offers_model.dart';
import '../model_class/restaurants_models/veg_option_list_model.dart';

final restaurantAPIProvider = Provider<RestaurantRepoService>((ref) => RestaurantRepoService());

class RestaurantRepoService {

  static Future fetchOffers({required id}) async {

    String url = "http://3.110.75.42:3009/api/v1/customer/menu/offer_list?page=1&perPage=10&storeId=$id";

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
        final List list = result["data"];
        return  list.map((e) => FetchOffers.fromJson(e)).toList();
      }
    } on HttpException {
      rethrow;
    }
  }

  static Future fetchVegOptionList() async {
    String url = "http://3.110.75.42:3009/api/v1/customer/content/foodCategory-list";

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
        final List list = result["data"]["foodCategoryList"];
        return  list.map((e) => VegOptionList.fromJson(e)).toList();

      }
    } on HttpException {
      rethrow;
    }
  }

  static Future fetchMenuItems({required id, required veg_nonveg_id}) async {

    String url = "http://3.110.75.42:3009/api/v1/customer/menu/store-menu?storeId=$id&foodCategoryId=$veg_nonveg_id";

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
        // final result =  json.decode(response.body);
        // final List list = result["data"]["array"];
        return json.decode(response.body);

      }
    } on HttpException {
      rethrow;
    }
  }
}