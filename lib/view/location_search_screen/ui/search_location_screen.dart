import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_examples/view/main_screen/ui/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widgets/image_assets.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../../../common_widgets/network_api.dart';
import '../../../controller/location_controller.dart';
import '../../../keys/api_keys.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/util.dart';
import '../../main_screen/widget/search_box_widget.dart';


class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  String input = "", placeId = "";
  List<dynamic> searchResponse = [];
  late double latitude = 0, longitude = 0;
  int listLength = 4;

  bool isLoading = false;

  String addressLine1 = "",
      addressLine2 = "",
      city = "",
      state = "",
      zipCode = "",
      countryCode = "",
      fullAddress = "",
      googlePlaceId = "",
      headerLocationText = "";

  LocationController? locationController;

  @override
  void initState() {
    // locationController = Get.find<LocationController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () {
                        dismissKeyboard(context);
                        Navigator.of(context).pop();
                      },
                      icon: backArrowIcon,
                      splashRadius: 20,
                    ),
                    Expanded(
                      child: SearchBoxWidget(
                        hintText: 'Search for area, street',
                        autofocus: true,
                        margin: const EdgeInsets.only(
                          left: 8,
                          right: 20,
                        ),
                        border: Border.all(color: kBoxBorderColor),
                        onChanged: (value) async {
                          if (value.isNotEmpty) {
                            var response = await http.get(
                              Uri.parse(
                                  "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&key=${APIKey.mapsApiKey}&radius=50"),
                            );

                            if (response.statusCode == 200) {
                              var data = jsonDecode(response.body);
                              searchResponse = data["predictions"];

                              log(jsonEncode(searchResponse));

                              if (searchResponse.isEmpty) return;

                              setState(() {
                                // if (searchResponse.length <= 3) {
                                //   listLength = 3;
                                // }
                                // if (searchResponse.length <= 4) {
                                //   listLength = 4;
                                // } else if (searchResponse.length > 4 &&
                                //     searchResponse.length < 6) {
                                //   listLength = 5;
                                // } else if (searchResponse.length > 6) {
                                //   listLength = 7;
                                // }
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (searchResponse.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchResponse.length,
                      itemBuilder: (c, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                placeId = searchResponse[index]["place_id"];

                                setState(() {
                                  isLoading = true;
                                });

                                var postionResponse = await http.get(Uri.parse(
                                    "https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=${APIKey.mapsApiKey}"));
                                // log(postionResponse.body);
                                if (postionResponse.statusCode == 200) {
                                  var data = jsonDecode(postionResponse.body);

                                  parseTappedTile(data["results"][0]);

                                  // double lat = data["results"][0]["geometry"]
                                  //     ["location"]["lat"];
                                  // double long = data["results"][0]["geometry"]
                                  //     ["location"]["lng"];

                                  // await getCurrentLocationWithAddress(
                                  //     lat, long);

                                  var response = await NetworkApi.post200(
                                    "address/add",
                                    {
                                      "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
                                      "deviceType": "iOS",
                                      "timezone": "Asia/Kolkata",
                                      "language": "en",
                                      "currentVersion": "16.2",
                                      "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk"
                                    },
                                    {
                                      "addressLine1": addressLine1,
                                      "addressLine2": addressLine2,
                                      "city": city,
                                      "state": state,
                                      "zipCode": zipCode,
                                      "countryCode": countryCode,
                                      "fullAddress": fullAddress,
                                      "googlePlaceId": googlePlaceId,
                                      "lat": latitude.toString(),
                                      "lng": longitude.toString(),
                                    },
                                  );

                                  print(response);
                                  if (response["code"] == 401) {
                                    showSnackbar(
                                      context: context,
                                      title: response["message"],
                                      duration: const Duration(seconds: 4),
                                    );
                                    // Get.find<CartController>().clearAllData();
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    if (await prefs.clear() && mounted) {
                                      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (_) => MainScreens(
                                            position: position,
                                          ),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                    return;
                                  }

                                  if (response["code"] != 200) {
                                    showSnackbar(
                                      context: context,
                                      title: response["message"],
                                    );
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }

                                  setState(() {
                                    isLoading = false;
                                  });

                                  // print("jroute response");

                                  if (!response["data"]["vendor"] && mounted) {
                                    showChangeLocationDialog(context);
                                  } else {
                                    locationController
                                        ?.updateLocationToggleStatus(false);
                                    locationController?.saveLatLong(
                                      latitude,
                                      longitude,
                                      city,
                                      state,
                                      zipCode,
                                      addressLine1,
                                      headerLocationText,
                                    );
                                    // Navigator.of(context).pushAndRemoveUntil(
                                    //   MaterialPageRoute(
                                    //       builder: (_) => const MyHomeScreen()),
                                    //   (route) => false,
                                    // );
                                    Position position = Position(longitude: longitude, latitude: latitude, timestamp: DateTime.now(), accuracy: 100.00, altitude: 100.00, heading: 100.00, speed: 100.00, speedAccuracy: 100.00);
                                    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                    print(position);
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (_) => MainScreens(
                                            position: position
                                          )),
                                      (route) => false,
                                    );
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: kAccentColor,
                                    ),
                                    const SizedBox(width: 14),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LimitedBox(
                                          maxWidth: 290,
                                          child: Text(
                                            searchResponse[index][
                                                        "structured_formatting"]
                                                    ["main_text"] ??
                                                "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: mediumBoldTextStyle.copyWith(
                                              color: kBlackTextColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        LimitedBox(
                                          maxWidth: 290,
                                          child: Text(
                                            searchResponse[index]
                                                    ["description"] ??
                                                "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: kLightTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Divider(height: 0)
                          ],
                        );
                      },
                    ),
                  )
              ],
            ),
            Visibility(
              visible: isLoading,
              child: Scaffold(
                backgroundColor: kScaffoldBackgroundColor.withOpacity(0.4),
                body: const SafeArea(
                  child: Center(
                    child: LoadingIndicator(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void parseTappedTile(dynamic data) {
    googlePlaceId = data["place_id"];
    fullAddress = data["formatted_address"];
    headerLocationText = fullAddress;
    addressLine1 = addressLine2 = headerLocationText;
    latitude = data["geometry"]["location"]["lat"];
    longitude = data["geometry"]["location"]["lng"];
    for (var element in data["address_components"]) {
      if (element["types"].contains("postal_code")) {
        zipCode = element["long_name"];
      } else if (element["types"].contains("country")) {
        countryCode = element["short_name"];
      } else if (element["types"].contains("administrative_area_level_1")) {
        state = element["long_name"];
      } else if (element["types"].contains("locality")) {
        city = element["long_name"];
      }
    }

    setState(() {});
  }

  // Future<void> getCurrentLocationWithAddress(double lat, double long) async {
  //   // var position = await determinePosition();
  //   // latitude = position.latitude;
  //   // longitude = position.longitude;
  //   var response = await http.get(Uri.parse(
  //       "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${APIKey.mapsApiKey}"));
  //   var decodedResponse = jsonDecode(response.body);
  //   if (decodedResponse["status"] != "OK") {
  //     return;
  //   }
  //   var data = decodedResponse["results"][0];
  //   googlePlaceId = data["place_id"];
  //   fullAddress = data["formatted_address"];
  //   headerLocationText = fullAddress;
  //   addressLine1 = addressLine2 = headerLocationText;
  //   latitude = data["geometry"]["location"]["lat"];
  //   longitude = data["geometry"]["location"]["lng"];
  //   for (var element in data["address_components"]) {
  //     if (element["types"].contains("postal_code")) {
  //       zipCode = element["long_name"];
  //     } else if (element["types"].contains("country")) {
  //       countryCode = element["short_name"];
  //     } else if (element["types"].contains("administrative_area_level_1")) {
  //       state = element["long_name"];
  //     } else if (element["types"].contains("locality")) {
  //       city = element["long_name"];
  //     }
  //   }
  //   // var placemark = await placemarkFromCoordinates(lat, long);
  //   // var place = placemark[0];
  //   // fullAddress =
  //   //     "${place.name} ${place.street} ${place.subLocality} ${place.subAdministrativeArea}, ${place.administrativeArea} ${place.country}";
  //   // headerLocationText =
  //   //     "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.subAdministrativeArea} ${place.country}";
  //   // countryCode = place.isoCountryCode ?? "";
  //   // state = place.administrativeArea ?? "";
  //   // addressLine1 = "${place.name} ${place.street}";
  //   // addressLine2 = "${place.subAdministrativeArea} ${place.administrativeArea}";
  //   // city = place.subAdministrativeArea!.isNotEmpty
  //   //     ? place.subAdministrativeArea!
  //   //     : place.locality ?? "";
  //   // zipCode = place.postalCode ?? "";
  //   // latitude = lat;
  //   // longitude = long;
  //   setState(() {
  //     // isfetchingLocation = false;
  //   });
  // }

}
