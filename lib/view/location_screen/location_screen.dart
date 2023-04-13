import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_widgets/backArrowAppBar.dart';
import '../../common_widgets/image_assets.dart';
import '../../common_widgets/loading_indicator.dart';
import '../../common_widgets/network_api.dart';
import '../../controller/location_controller.dart';
import '../../keys/api_keys.dart';
import '../../utils/colors.dart';
import '../../utils/util.dart';
import '../location_search_screen/ui/search_location_screen.dart';
import '../main_screen/ui/main_screen.dart';
import '../main_screen/widget/search_box_widget.dart';

class LocationScreen extends StatefulWidget {
  bool canBack;
  LocationScreen({super.key, this.canBack = false});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double latitude = 0.0, longitude = 0.0;
  // ApiHeaders controller = Get.find<ApiHeaders>();
  LocationController? locationController;

  bool isfetchingLocation = true, isLoading = false;
  String headerLocationText = "";

  String addressLine1 = "",
      addressLine2 = "",
      city = "",
      state = "",
      zipCode = "",
      countryCode = "",
      fullAddress = "",
      googlePlaceId = "",
      lat = "",
      lng = "";

  @override
  void initState() {
    getCurrentLocationWithAddress();

    // headersMap = controller.getHeadersMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: widget.canBack ? backArrowAppBar(context: context) : null,
      body: SafeArea(
        child: isfetchingLocation
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Spacer(),
                    changeLocationIcon,
                    SizedBox(height: 10),
                    Text(
                      'Fetching your location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    LoadingIndicator(),
                    Spacer(flex: 2),
                  ],
                ),
              )
            : Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: widget.canBack ? 10 : 60),
                      changeLocationIcon,
                      const SizedBox(height: 21),
                      const Text(
                        'Select current location',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 21),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });

                          if (await getCurrentLocationWithAddress()) {
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
                                // Navigator.of(
                                //   context,
                                //   rootNavigator: true,
                                // ).pushAndRemoveUntil(
                                //   MaterialPageRoute(
                                //     builder: (_) => const LoginScreen(),
                                //   ),
                                //   (route) => false,
                                // );
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
                              if (mounted) {
                                showChangeLocationDialog(context);
                              }
                              return;
                            }

                            if (!response["data"]["vendor"] && mounted) {
                              setState(() {
                                isLoading = false;
                                print(isLoading);
                              });

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
                              //     builder: (_) => const MyHomeScreen(),
                              //   ),
                              //   (route) => false,
                              // );
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => MainScreens(),
                                ),
                                (route) => false,
                              );
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gpsIcon,
                              const SizedBox(width: 10),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Current Location',
                                    style: TextStyle(
                                      fontFamily: 'SFPRODISPLAYMEDIUM',
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Using GPS',
                                    style: TextStyle(
                                      fontFamily: 'SFPRODISPLAYREGULAR',
                                      fontSize: 11,
                                      color: kLightestTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Text(
                                'or',
                                style: TextStyle(
                                  color: kLightestTextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const LocationSearchScreen()),
                                );
                              },
                              child: SearchBoxWidget(
                                enabled: false,
                                hintText: 'Search for area, street',
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 20),
                                border: Border.all(color: kBoxBorderColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: isLoading,
                    child: Scaffold(
                      backgroundColor:
                          kScaffoldBackgroundColor.withOpacity(0.2),
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

  Future<bool> getCurrentLocationWithAddress() async {
    var position = await determinePosition();
    if (position == "df") {
      showSnackbar(
        context: context,
        title: "Grant Location permission",
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: "OPEN SETTINGS",
          onPressed: () {
            Geolocator.openAppSettings();
          },
          textColor: kAccentColor,
        ),
      );
      if (mounted) {
        setState(() {
          isfetchingLocation = false;
          isLoading = false;
        });
      }
      return false;
    }
    if (position == null) {
      showSnackbar(
        context: context,
        title: "Could not fetch your current location",
      );
      if (mounted) {
        setState(() {
          isfetchingLocation = false;
          isLoading = false;
        });
      }
      return false;
    }

    latitude = position.latitude;
    longitude = position.longitude;

    var response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${APIKey.mapsApiKey}"));

    var decodedResponse = jsonDecode(response.body);
    print(decodedResponse);
    if (decodedResponse["status"] != "OK") {
      return false;
    }

    var data = decodedResponse["results"][0];

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

    // var placemark = await placemarkFromCoordinates(latitude, longitude);

    // var place = placemark[0];

    // print(place);

    // fullAddress =
    //     "${place.name} ${place.street} ${place.subLocality} ${place.subAdministrativeArea}, ${place.administrativeArea} ${place.country}";

    // print("full address$fullAddress");
    // headerLocationText =
    //     "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.subAdministrativeArea} ${place.country}";
    // countryCode = place.isoCountryCode ?? "";
    // state = place.administrativeArea ?? "";
    // addressLine1 = "${place.name} ${place.street}";
    // addressLine2 = "${place.subAdministrativeArea} ${place.administrativeArea}";
    // city = place.subAdministrativeArea!.isNotEmpty
    //     ? place.subAdministrativeArea!
    //     : place.locality ?? "";
    // zipCode = place.postalCode ?? "";
    // lat = latitude.toString();
    // lng = longitude.toString();

    if (mounted) {
      setState(() {
        isfetchingLocation = false;
      });
    }
    return true;
  }
}
