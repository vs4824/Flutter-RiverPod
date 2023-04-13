import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widgets/backArrowAppBar.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../../../common_widgets/network_api.dart';
import '../../../common_widgets/search_suggestion_box.dart';
import '../../../controller/cart_controller.dart';
import '../../../controller/location_controller.dart';
import '../../../provider/search_screen_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/debouncer.dart';
import '../../../utils/util.dart';
import '../../main_screen/widget/search_box_widget.dart';
import '../../restaurant_screen/ui/restaurant_screen.dart';

BuildContext? context;

class SearchScreen extends ConsumerWidget {
  final String? id;

  SearchScreen({super.key,this.id});

  String search = '';
  bool _isLoading = true, _isFetchingRestaurant = false;
  List suggestionList = [];
  dynamic recentSearchList = [];
  dynamic trendingSearchList = [];

  final LocationController locationController = LocationController();

  final TextEditingController textController = TextEditingController();

  Future<bool> saveSearch(String text) async {
    var response = await NetworkApi.getResponse(
      url: "home/searchSave?title=$text&storeTypeId=$id",
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
        context: context!,
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

    print(response);

    if (response["code"] != 200) {
      showSnackbar(
        context: context!,
        title: response["message"],
      );
      return false;
    }

    return response["code"] == 200;
  }

  @override
  Widget build(BuildContext context,ref) {
    final searchData = ref.watch(fetchSearchDataNotifierProvider);

    if(searchData.isNotEmpty){
      recentSearchList = searchData["data"]["RecentSearch"];
      trendingSearchList = searchData["data"]["trandingData"];
      _isLoading = false;
    }

    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: backArrowAppBar(context: context),
      body: searchData.isNotEmpty ? SafeArea(
        child: Stack(
          children: [
            ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: SearchBoxWidget(
                    controller: textController,
                    autofocus: true,
                    hintText: 'Search for restaurant, items or more',
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    border: Border.all(color: kBoxBorderColor),
                    suffixIcon: IconButton(
                      onPressed: () {
                        textController.clear();
                        // setState(() {
                          search = "";
                          suggestionList.clear();
                        // });
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: kLightTextColor,
                        size: 20,
                      ),
                      splashRadius: 1,
                    ),
                    onChanged: (value) {
                      search = value;
                      if (search.isNotEmpty) {
                        final debouncer = Debouncer(milliseconds: 500);
                        debouncer.run(() {
                          ref.read(valueProvider.notifier).state = search;
                          final searchData = ref.watch(fetchSearchDataNotifierProvider);
                          if(searchData.isNotEmpty)suggestionList = searchData["data"]["shoplist"];
                          // searchFromApi(search);
                        });
                      } else {
                        // setState(() {
                          search = "";
                          textController.clear();
                          suggestionList.clear();
                        // });
                      }
                    },
                  ),
                ),
                search.isEmpty //&& suggestionList.isEmpty
                    ? ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    _isLoading
                        ? const LoadingIndicator()
                        : (recentSearchList.isNotEmpty ||
                        trendingSearchList.isNotEmpty)
                        ? Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        if (recentSearchList.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 19),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Recent Search',
                                  style: TextStyle(
                                    fontFamily:
                                    'Montserrat-Medium',
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: recentWidgetList(),
                                ),
                                const SizedBox(height: 20),
                                const Divider(
                                  height: 0,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        if (trendingSearchList.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 19),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Trending Searches',
                                  style: TextStyle(
                                    fontFamily:
                                    'Montserrat-Medium',
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children:
                                  trendingWidgetList(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )
                        : const SizedBox.shrink(),
                  ],
                )
                    : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  padding: const EdgeInsets.only(left: 18, top: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kBoxBorderColor),
                  ),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: searchList(),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _isFetchingRestaurant,
              child: Scaffold(
                backgroundColor: Colors.grey[100]!.withOpacity(0.3),
                body: const SafeArea(
                  child: Center(
                    child: LoadingIndicator(),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  List<Widget> searchList() {
    List<Widget> list = [];

    if (textController.text.isNotEmpty && suggestionList.isEmpty) {
      list.add(Center(
          child: Column(
            children: const [
              Text("No restaurant for this search"),
              SizedBox(height: 15),
            ],
          )));
      return list;
    }
    for (var item in suggestionList) {
      list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                print(item["main_branchName"]);
                await getRestaurant(item["main_branchName"], true);
              },
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["branchName"] ?? "",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item["distance"].toStringAsFixed(2)} kms | ${item["city"]}',
                        style: const TextStyle(
                          fontFamily: 'Montserrat-Light',
                          fontSize: 11,
                          color: kLightestTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 30),
          ],
        ),
      );
    }
    return list;
  }

  Future<void> getRestaurant(String item, bool isSaveSearch) async {
    if (item.isNotEmpty) {
      // setState(() {
        _isFetchingRestaurant = true;
      // });

      if (isSaveSearch) {
        await saveSearch(item);
      }
      var restaurantData = await fetchRestaurant(item);

      if (restaurantData == 0) {
        // setState(() {
          _isFetchingRestaurant = false;
        // });
        showSnackbar(
          context: context!,
          title: "This restaurant is not available",
        );
        return;
      }

      // setState(() {
        _isFetchingRestaurant = false;
      // });

      if (!restaurantData["near_restaurantAvailable"]) {
        showSnackbar(
          context: context!,
          title: "This restaurant is not available for this location",
        );
        return;
      }

      if (!(restaurantData["online_status"] &&
          restaurantData["isActive"] &&
          restaurantData["hightItemAmount"] != 0)) {
        showSnackbar(
          context: context!,
          title: "This restaurant is not available",
        );
        return;
      }

      if (restaurantData != null) {
        Navigator.of(context!).pushReplacement(
          MaterialPageRoute(
            builder: (_) => RestaurantScreen(
              data: restaurantData,
              isFavorite: restaurantData["favourite"],
            ),
          ),
        );
      }
    }
  }

  List<Widget> recentWidgetList() {
    List<Widget> list = [];

    for (var item in recentSearchList) {
      list.add(
        GestureDetector(
          onTap: () async {
            print("${item["title"]}");
            await getRestaurant(item["title"], false);
          },
          child: SearchSuggestionWidget(
            text: item["title"],
            isTrending: false,
          ),
        ),
      );
    }

    return list;
  }

  List<Widget> trendingWidgetList() {
    List<Widget> list = [];

    for (var item in trendingSearchList) {
      list.add(
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return GestureDetector(
              onTap: () {
                textController.text = item["title"];
                textController.selection = TextSelection(
                  baseOffset: item["title"].length,
                  extentOffset: item["title"].length,
                );

                search = textController.text;
                ref.read(valueProvider.notifier).state = search;
                final searchData = ref.watch(fetchSearchDataNotifierProvider);
                if(searchData.isNotEmpty)suggestionList = searchData["data"]["shoplist"];
              },
              child: SearchSuggestionWidget(
                text: item["title"],
                isTrending: true,
              ),
            );
          },
        ),
      );
    }

    return list;
  }

  Future<dynamic> fetchRestaurant(String search) async {
    final response = await NetworkApi.getResponse(
      url:
      "home/get-restaurant?lat=${locationController.lat}&lng=${locationController.long}&search=$search",
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
        context: context!,
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
    print(response);
    if (response["code"] != 200) {
      showSnackbar(
        context: context!,
        title: response["message"],
      );
      return;
    }
    if (response["data"]["categegoryItems"].isEmpty) {
      return 0;
    }

    return response["data"]["categegoryItems"][0];
  }
}

// Container(
//                       padding: const EdgeInsets.only(left: 18, top: 15),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: kBoxBorderColor),
//                       ),
//                       child: Column(
//                         children: searchList(),
//                       ),
//                     )
