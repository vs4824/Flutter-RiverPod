import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_examples/common_widgets/star_rating_widget.dart';
import 'package:riverpod_examples/common_widgets/yellow_btn_widget.dart';
import 'package:riverpod_examples/controller/cart_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/util.dart';
import 'backArrowAppBar.dart';
import 'image_assets.dart';
import 'loading_indicator.dart';
import 'network_api.dart';


class PickupTimeScreen extends StatefulWidget {
  final dynamic detail;
  const PickupTimeScreen({super.key, this.detail});

  @override
  State<PickupTimeScreen> createState() => _PickupTimeScreenState();
}

class _PickupTimeScreenState extends State<PickupTimeScreen> {
  final CartController cartController = CartController();

  List<String> weekday = [];
  List<String> month = [];
  List<String> day = [];
  List<String> datesList = [];

  List timeSlots = [];

  bool isLoading = true, isUploading = false;

  String selectedTime = "";
  String selectedDay = "";

  void initializeDates() {
    DateTime dateTime = DateTime.now();

    day.add('Today');
    day.add('Tomorrow');

    for (var i = 0; i < 7; i++) {
      weekday.add(
        DateFormat('EEEE')
            .format(dateTime.add(Duration(days: i)))
            .substring(0, 3),
      );

      month.add(
        DateFormat.MMMM().format(dateTime).toString().substring(0, 3),
      );

      datesList.add(dateFormatter(dateTime.add(Duration(days: i))));
    }

    for (var i = 0; i < month.length; i++) {
      if (i >= 2) {
        day.add("${dateTime.add(Duration(days: i)).day} ${month[i]}");
      }
    }

    selectedDay = datesList[0];
  }

  void fetchTimeSlots(String date) async {
    var response = await NetworkApi.getResponse(
      url:
          "order/GetTimeSlot?bookingDate=$date&storeId=${widget.detail["_id"]}",
      headers: {
        "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
        "deviceType": "iOS",
        "timezone": "Asia/Kolkata",
        "language": "en",
        "currentVersion": "16.2",
        "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk"
      },
    );

    if (response["code"] == 401) {
      showSnackbar(
        context: context,
        title: response["message"],
        duration: const Duration(seconds: 4),
      );
      cartController.clearAllData();
      final prefs = await SharedPreferences.getInstance();
      // if (await prefs.clear() && mounted) {
      //   Navigator.of(
      //     context,
      //     rootNavigator: true,
      //   ).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (_) => const LoginScreen(),
      //     ),
      //     (route) => false,
      //   );
      // }
      return;
    }

    print(response);

    if (response["code"] != 200) {
      showSnackbar(
        context: context,
        title: response["message"],
      );
      return;
    }

    setState(() {
      isLoading = false;
      timeSlots = response["data"];
    });
  }

  @override
  void initState() {
    initializeDates();
    fetchTimeSlots(selectedDay);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isUploading) return false;
        return true;
      },
      child: Scaffold(
        appBar: backArrowAppBar(
          context: context,
          isIgnoring: isUploading,
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: kScaffoldBackgroundColor,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StarRatingWidget(
                                rating:
                                    '${widget.detail["rating"].toStringAsFixed(1)}'),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 245,
                                  child: Text(
                                    '${widget.detail["branchName"]}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: kBlackTextColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                //SHARE ICON
                                IconButton(
                                  padding: const EdgeInsets.all(0.0),
                                  alignment: Alignment.centerRight,
                                  onPressed: () async {
                                    print("share plus");
                                    final urlImage = widget.detail["image"];
                                    final response =
                                        await http.get(Uri.parse(urlImage));
                                    final bytes = response.bodyBytes;

                                    final temp = await getTemporaryDirectory();
                                    final path = "${temp.path}/image.jpg";
                                    File(path).writeAsBytes(bytes);

                                    Share.shareFiles(
                                      [path],
                                      text: "JRoute welcomes you",
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.share_rounded,
                                    color: kLightTextColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // locationIcon,
                                    const Icon(
                                      Icons.location_on,
                                      color: kAccentColor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 3),
                                    LimitedBox(
                                      maxWidth: 200,
                                      child: Text(
                                        "${widget.detail["fullAddress"]}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: kLightTextColor),
                                      ),
                                    ),
                                    Text(
                                      ' | ${widget.detail["dictance"].toStringAsFixed(2)} km',
                                      style: const TextStyle(
                                          color: kLightTextColor),
                                    ),
                                  ],
                                ),
                                //REDIRECT TO MAPS
                                InkWell(
                                  onTap: () async {
                                    print("redirect to maps");
                                    if (widget.detail["lat"] != null &&
                                        widget.detail["lng"] != null) {
                                      redirectToMaps(
                                        lat: widget.detail["lat"],
                                        long: widget.detail["lng"],
                                        title: widget.detail["branchName"],
                                      );
                                    }
                                  },
                                  child: moveToLocation,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 0,
                        thickness: 1,
                        color: kBoxBorderColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose pickup slot for this address',
                        style: mediumBoldTextStyle.copyWith(
                          color: kBlackTextColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 22),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: selectDay(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                isLoading
                    ? const LoadingIndicator()
                    : Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            spacing: 12,
                            runSpacing: 15,
                            children: timeSlotsWidgets(),
                          ),
                        ],
                      ),
                const SizedBox(height: 30),
              ],
            ),
            Visibility(
              visible: isUploading,
              child: Scaffold(
                backgroundColor: Colors.grey[100]!.withOpacity(0.3),
                body: const SafeArea(
                  child: Center(
                    child: LoadingIndicator(),
                  ),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: IgnorePointer(
          ignoring: isUploading,
          child: GestureDetector(
            onTap: () async {
              if (selectedTime.isEmpty) {
                showSnackbar(
                  context: context,
                  title: "Please choose a time slot",
                );
                return;
              }

              bool isSuccess = await editCartDetails();

              // if (isSuccess && mounted) {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(builder: (_) => const PaymentScreen()),
              //   );
              // }
            },
            child: const YellowButtonWidget(
              text: 'Proceed to pay',
              fontSize: 16,
              margin: EdgeInsets.only(
                top: 10,
                bottom: 18,
                left: 18,
                right: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> selectDay() {
    List<Widget> list = [];

    for (var i = 0; i < datesList.length; i++) {
      list.add(
        SizedBox(
          height: 65,
          width: 65,
          child: IgnorePointer(
            ignoring: isLoading,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedDay = datesList[i];
                  isLoading = true;
                  selectedTime = "";
                  fetchTimeSlots(selectedDay);
                });
              },
              child: Container(
                height: 62,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: selectedDay == datesList[i]
                      ? kScaffoldBackgroundColor
                      : null,
                  border: Border.all(
                      color: selectedDay == datesList[i]
                          ? kAccentColor
                          : Colors.transparent),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weekday[i],
                      style:
                          mediumBoldTextStyle.copyWith(color: kBlackTextColor),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      day[i],
                      style: lightTextStyle.copyWith(
                        color: kLightTextColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return list;
  }

  List<Widget> timeSlotsWidgets() {
    List<Widget> list = [];

    for (int i = 0; i < timeSlots.length; i++) {
      list.add(
        GestureDetector(
          onTap: () {
            print(timeSlots[i]);
            setState(() {
              selectedTime = timeSlots[i].toString();
            });
          },
          child: Container(
            height: 40,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selectedTime == timeSlots[i].toString()
                  ? kScaffoldBackgroundColor
                  : Colors.white,
              border: Border.all(
                color: selectedTime == timeSlots[i].toString()
                    ? kAccentColor
                    : kBoxBorderColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              (selectedDay == datesList[0] && i == 0)
                  ? "Right Now"
                  : convert24hrToTimeString(timeSlots[i]),
              style: TextStyle(
                fontSize: 12,
                color: selectedTime == timeSlots[i].toString()
                    ? kBlackTextColor
                    : kLightestTextColor,
              ),
            ),
          ),
        ),
      );
    }

    return list;
  }

  Future<bool> editCartDetails() async {
    try {
      setState(() {
        isUploading = true;
      });

      var response = await NetworkApi.post(
        "order/edit",
        {
        "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
        "deviceType": "iOS",
        "timezone": "Asia/Kolkata",
        "language": "en",
        "currentVersion": "16.2",
        "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk",
          "Content-type": "application/json",
          "Accept": "application/json",
        },
        cartController.compileAllCart(
          status: "Add to cart",
          pickupDate: selectedDay,
          pickupTime: selectedTime,
          pickupDateTime: "$selectedDay $selectedTime",
        ),
      );
      if (response["code"] == 401) {
        showSnackbar(
          context: context,
          title: response["message"],
          duration: const Duration(seconds: 4),
        );
        CartController().clearAllData();
        final prefs = await SharedPreferences.getInstance();
        // if (await prefs.clear() && mounted) {
        //   Navigator.of(
        //     context,
        //     rootNavigator: true,
        //   ).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (_) => const LoginScreen(),
        //     ),
        //     (route) => false,
        //   );
        // }
        return false;
      }

      if (response["code"] != 201) {
        print("add order api");
        showSnackbar(
          context: context,
          title: response["message"],
        );

        setState(() {
          isUploading = false;
        });

        if (mounted) {
          Navigator.of(context).pop();
        }
        return false;
      }

      setState(() {
        isUploading = false;
      });

      print(response);
      return response["data"]["success"];
    } on Exception catch (e) {
      print(e);
      setState(() {
        isUploading = false;
      });

      return false;
    }
  }
}
