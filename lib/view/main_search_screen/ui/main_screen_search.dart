import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_examples/view/main_screen/ui/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widgets/backArrowAppBar.dart';
import '../../../common_widgets/network_api.dart';
import '../../../controller/cart_controller.dart';
import '../../../model_class/homepage_models/food_category_model.dart';
import '../../../provider/food_main_page_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/util.dart';
import '../../food_main_screen/ui/food_main_screen.dart';
import '../../main_screen/widget/search_box_widget.dart';


class MainScreenSearch extends StatefulWidget {
  final List<FoodCategoryModel>? categoryList;
  const MainScreenSearch({super.key, this.categoryList});

  @override
  State<MainScreenSearch> createState() => _MainScreenSearchState();
}

class _MainScreenSearchState extends State<MainScreenSearch> {
  List suggestionList = [];
  String search = "";
  bool isEmpty = false;
  String storeTypeId = "";

  final TextEditingController textController = TextEditingController();

  Future<List> searchFromApi(String value) async {
    try {
      var response = await NetworkApi.getResponse(
        url: "home/storeType-list?search=$value",
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
        return [];
      }

      print(response);

      if (response["code"] != 200) {
        // showSnackbar(
        //   context: context,
        //   title: response["message"],
        // );
        return [];
      }
      return response["data"]["items"];
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: backArrowAppBar(context: context),
      body: SafeArea(
        child: Column(
          children: [
            SearchBoxWidget(
              controller: textController,
              autofocus: true,
              hintText: 'Search for restaurant, items or more',
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              border: Border.all(color: kBoxBorderColor),
              suffixIcon: IconButton(
                onPressed: () {
                  textController.clear();
                  setState(() {
                    search = "";
                    suggestionList = [];
                    isEmpty = false;
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: kLightTextColor,
                  size: 20,
                ),
              ),
              onChanged: (value) async {
                if (value.isNotEmpty) {
                  search = value;
                  suggestionList = await searchFromApi(search);
                  setState(() {
                    suggestionList.isEmpty ? isEmpty = true : isEmpty = false;
                  });
                } else {
                  setState(() {
                    search = "";
                    suggestionList = [];
                  });
                }
              },
            ),
            isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Text("No store type with this search"),
                  )
                : search.isEmpty && suggestionList.isEmpty
                    ? Container(
                        padding: const EdgeInsets.only(left: 18, top: 15),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kBoxBorderColor),
                        ),
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: searchList(widget.categoryList),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(left: 18, top: 15),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kBoxBorderColor),
                        ),
                        child: ListView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          shrinkWrap: true,
                          children: searchList(widget.categoryList),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  List<Widget> searchList(List<FoodCategoryModel>? dataList) {
    List<Widget> list = [];
    for (FoodCategoryModel item in dataList!) {
      list.add(
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        storeTypeId = item.sId!;
                        ref.read(fetchIdProvider.notifier).state = storeTypeId;
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FoodMainScreen()));
                      },
                      child: Row(
                        children: [
                          Text(
                            item.storeType ?? "",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),
              ],
            );
          },
        ),
      );
    }
    return list;
  }
}
