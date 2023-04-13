import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart' as maps;

import '../common_widgets/image_assets.dart';
import '../common_widgets/yellow_btn_widget.dart';


ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar({
  required BuildContext context,
  required String title,
  Duration duration = const Duration(milliseconds: 2000),
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      action: action,
    ),
  );
}

//2023-01-05T00: 00: 00.000Z to 05 Jan, 2023
String dateTimeTZToDateStringFormat(String dateTime) {
  DateTime tempDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(dateTime);
  return DateFormat('dd MMM, yyyy').format(tempDate);
}

String convert24hrToTimeString(String time) {
  return DateFormat("hh:mm a").format(DateFormat.Hm().parse(time));
}

//2022-12-22 18:45 to 22 Dec 2022
String dateTimeToDateStringFormat(String dateTime) {
  DateTime tempDate =
  DateFormat("yyyy-MM-dd HH:mm").parse(dateTime); //2022-12-22 18:45
  return DateFormat('dd MMM yyyy').format(tempDate);
}

//2022-12-22 18:45 to 6:45 PM
String dateTimeToTimeStringFormat(String dateTime) {
  DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm").parse(dateTime);
  return DateFormat('hh:mm a').format(tempDate);
}

//3:00 PM to 15:00
String timeStringTo24HourFormat(String time) =>
    DateFormat("HH:mm").format(DateFormat.jm().parse(time));

//yyyy-MM-dd
String dateFormatter(DateTime dateTime) {
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  return dateFormatter.format(dateTime);
}

//HH:mm
String timeFormatter(DateTime dateTime) {
  final DateFormat timeFormatter = DateFormat('HH:mm');
  return timeFormatter.format(dateTime);
}

//15:00 to 3:00 PM
String timeFormatterAmPm(String time) {
  return DateFormat.jm().format(DateFormat("HH:mm").parse(time));
}

//yyyy-MM-dd HH:mm'
String dateTimeFormatter(DateTime dateTime) {
  final DateFormat dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm');
  return dateTimeFormatter.format(dateTime);
}

Future<String> getTimeZone() async {
  try {
    return await FlutterNativeTimezone.getLocalTimezone();
  } on MissingPluginException catch (e) {
    return "";
    print(e);
  } on Exception catch (e) {
    print(e);
    return "";
  }
}

Future<String> getDeviceType() async {
  return Platform.isAndroid
      ? "Android"
      : Platform.isIOS
      ? "iOS"
      : "";
}

Future<String> getDeviceModel() async {
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    print("${androidInfo.brand} ${androidInfo.device} ${androidInfo.model}");
    return "${androidInfo.brand} ${androidInfo.device} ${androidInfo.model}";
  } else if (Platform.isIOS) {
    var iosInfo = await DeviceInfoPlugin().iosInfo;
    return "${iosInfo.model} ${iosInfo.utsname.machine}";
  } else {
    return "";
  }
}

Future<String> getCurrentVersion() async {
  try {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;

      return androidInfo.version.release;
    } else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;

      return iosInfo.systemVersion ?? "";
    } else {
      return "";
    }
  } on Exception catch (e) {
    print(e);
    return "";
  }
}

void dismissKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

void redirectToMaps({
  required double lat,
  required double long,
  required String title,
}) async {
  try {
    if (Platform.isIOS) {
      if (await maps.MapLauncher.isMapAvailable(maps.MapType.google) ?? false) {
        maps.MapLauncher.showMarker(
          mapType: maps.MapType.google,
          coords: maps.Coords(
            lat,
            long,
          ),
          title: title,
          // destination: maps.Coords(
          //   widget.data["lat"],
          //   widget.data["lng"],
          // ),
        );
      } else {
        maps.MapLauncher.showMarker(
          mapType: maps.MapType.apple,
          coords: maps.Coords(
            lat,
            long,
          ),
          title: title,
        );
      }
    } else {
      maps.MapLauncher.showMarker(
        mapType: maps.MapType.google,
        coords: maps.Coords(
          lat,
          long,
        ),
        title: title,
      );
    }
  } on PlatformException catch (e) {
    print(e);
  } on Exception catch (e) {
    print(e);
  }
}

Future<dynamic> showChangeLocationDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (c) {
      return SimpleDialog(
        contentPadding: const EdgeInsets.all(25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              changeLocationIcon,
              const SizedBox(height: 18),
              const Text(
                'JRoute not available at this location please select a different location',
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Montserrat-Medium',
                ),
              ),
              const SizedBox(height: 28),
              GestureDetector(
                onTap: () {
                  Navigator.of(c).pop();
                },
                child: const YellowButtonWidget(
                  text: 'Change Location',
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ],
      );
    },
  );
}

Future<dynamic> determinePosition() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("service is not enabled");
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("premission denied second");
        return null;
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print("denied forever");
      return "df";
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  } on Exception catch (e) {
    print("service is not enabled exception");
    print(e);
    // return null;
  }
}

