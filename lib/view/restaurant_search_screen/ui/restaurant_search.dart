import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_widgets/image_assets.dart';
import '../../../common_widgets/network_api.dart';
import '../../../utils/colors.dart';
import '../../../utils/util.dart';
import '../../main_screen/widget/search_box_widget.dart';
import '../../restaurant_screen/ui/restaurant_screen.dart';

class RestaurantSearchScreen extends StatefulWidget {
  final String id;
  final List list;

  const RestaurantSearchScreen({
    super.key,
    required this.id,
    required this.list,
  });

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  List _allItemsList = [], _itemsList = [];
  String search = "";
  final TextEditingController textController = TextEditingController();

  dynamic searchItems(String value) async {
    var response = await NetworkApi.getResponse(
      url: "menu/store-menu?search=$value&storeId=${widget.id}",
        headers: {
          "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
          "deviceType": "iOS",
          "timezone": "Asia/Kolkata",
          "language": "en",
          "currentVersion": "16.2",
          "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk"
        }
        );

    if (response["code"] == 401) {
      showSnackbar(
        context: context,
        title: response["message"],
        duration: const Duration(seconds: 4),
      );
      // Get.find<CartController>().clearAllData();
      final prefs = await SharedPreferences.getInstance();
      if (await prefs.clear() && mounted) {
        // Navigator.of(
        //   context,
        //   rootNavigator: true,
        // ).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (_) => const LoginScreen(),
        //   ),
        //       (route) => false,
        // );
      }
      return;
    }

    if (response["code"] != 200) {
      showSnackbar(
        context: context,
        title: response["message"],
      );
      return;
    }

    return response["data"]["array"];
  }

  @override
  void initState() {
    _allItemsList = widget.list;
    _itemsList = _allItemsList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kScaffoldBackgroundColor,
        centerTitle: false,
        leading: IconButton(
          onPressed: () async {
            Navigator.pop(context, true);
          },
          icon: const Image(
            image: AssetImage('assets/images/arrowleftblack.png'),
          ),
        ),
      ),
      body: Column(
        children: [
          SearchBoxWidget(
            controller: textController,
            autofocus: true,
            hintText: 'Search for restaurant items',
            margin: const EdgeInsets.only(
              left: 18,
              right: 18,
              bottom: 0,
            ),
            border: Border.all(color: kBoxBorderColor),
            suffixIcon: IconButton(
              onPressed: () {
                textController.clear();
                setState(() {
                  _itemsList = _allItemsList;
                });
              },
              icon: const Icon(
                Icons.close_rounded,
                color: kLightTextColor,
                size: 20,
              ),
              splashRadius: 1,
            ),
            onChanged: (value) async {
              final suggestions = _allItemsList.where((item) {
                final title = item["itemName"].toLowerCase();
                final input = value.toLowerCase();
                return title.contains(input);
              }).toList();
              setState(() {
                _itemsList = suggestions;
              });
              // search = value;
              // if (search.isNotEmpty) {
              //   _allItemsList = await searchItems(search);
              //   setState(() {});
              // } else {
              //   setState(() {
              //     search = "";
              //     _allItemsList = [];
              //   });
              // }
            },
          ),
          _itemsList.isEmpty
              ? Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: const [
                  SizedBox(height: 50),
                  emptyPlaceholderIcon,
                  SizedBox(height: 10),
                  Text("No items with this search"),
                ],
              ),
            ),
          )
              : Expanded(
            child: ListView.builder(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _itemsList.length,
              itemBuilder: (context, index) {
                return RestaurantListItemTile(detail: _itemsList[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildSearchList() {
    List<Widget> list = [];
    for (var data in _allItemsList) {
      list.add(RestaurantListItemTile(detail: data));
    }
    return list;
  }
}
