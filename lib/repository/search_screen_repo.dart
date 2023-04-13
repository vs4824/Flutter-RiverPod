import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;


final searchAPIProvider = Provider<SearchRepoService>((ref) => SearchRepoService());

class SearchRepoService {

  static Future fetchSearchData({required String id}) async {
    String url = "http://3.110.75.42:3009/api/v1/customer/home/getSearchData?storeTypeId=$id";

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
        // final List list = result;
        return result;

      }
    } on HttpException {
      rethrow;
    }
  }

  static Future searchFromApi({required String value, id}) async {
    String url = "http://3.110.75.42:3009/api/v1/customer/home/getSearchData?storeTypeId=search/vendorShop-list?lat=28.616316264001956&lng=77.37723708175879&storeTypeId=$id&page=1&perPage=10&search=$value";

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
        // final List list = result;
        return result;

      }
    } on HttpException {
      rethrow;
    }
  }

  // static Future saveSearch({required String text}) async {
  //   String url = "http://3.110.75.42:3009/api/v1/customer/home/getSearchData?storeTypeId=$id";
  //
  //   var response = await http.get(Uri.parse(url),headers: {
  //     "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
  //     "deviceType": "iOS",
  //     "timezone": "Asia/Kolkata",
  //     "language": "en",
  //     "currentVersion": "16.2",
  //     "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk"
  //   });
  //
  //   try {
  //     if (response.statusCode == 200) {
  //       final result =  json.decode(response.body);
  //       // final List list = result;
  //       return result;
  //
  //     }
  //   } on HttpException {
  //     rethrow;
  //   }
  // }

}