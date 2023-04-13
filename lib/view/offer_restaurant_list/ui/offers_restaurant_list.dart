import 'package:flutter/material.dart';

import '../../../common_widgets/backArrowAppBar.dart';
import '../../../common_widgets/food_item_tile.dart';
import '../../../common_widgets/loading_indicator.dart';


class OfferRestaurantList extends StatefulWidget {
  // final String lat, long;
  final List stores;

  const OfferRestaurantList({
    super.key,
    // required this.lat,
    // required this.long,
    required this.stores,
  });

  @override
  State<OfferRestaurantList> createState() => _OfferRestaurantListState();
}

class _OfferRestaurantListState extends State<OfferRestaurantList> {
  bool isLoading = false;
  dynamic _responseList = [];

  // void fetchList() async {
  //   try {
  //     String arr = "";

  //     for (int i = 0; i < widget.stores.length; i++) {
  //       if (i != widget.stores.length - 1) {
  //         arr = "$arr${widget.stores[i]["_id"]},";
  //       } else {
  //         arr = arr + widget.stores[i]["_id"];
  //       }
  //     }

  //     var response = await NetworkApi.getResponse(
  //       url:
  //           "${getRestaurantWithOffersUrl}lat=${widget.lat}&lng=${widget.long}&storeId=$arr",
  //       headers: headersMap,
  //     );

  //     if (response["code"] == 401) {
  //       showSnackbar(
  //         context: context,
  //         title: response["message"],
  //         duration: const Duration(seconds: 4),
  //       );
  //       Get.find<CartController>().clearAllData();
  //       final prefs = await SharedPreferences.getInstance();
  //       if (await prefs.clear() && mounted) {
  //         Navigator.of(
  //           context,
  //           rootNavigator: true,
  //         ).pushAndRemoveUntil(
  //           MaterialPageRoute(
  //             builder: (_) => const LoginScreen(),
  //           ),
  //           (route) => false,
  //         );
  //       }
  //       return;
  //     }
  //     print(response);

  //     if (response["code"] != 200) {
  //       showSnackbar(
  //         context: context,
  //         title: response["message"],
  //       );
  //       setState(() {
  //         isLoading = false;
  //       });
  //       return;
  //     }

  //     setState(() {
  //       isLoading = false;
  //       _responseList = response["data"]["categegoryItems"];
  //     });
  //   } on Exception catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    // fetchList();
    _responseList = widget.stores;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backArrowAppBar(
        context: context,
      ),
      body: isLoading
          ? const Center(
              child: LoadingIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _responseList.length,
              itemBuilder: (conteeext, index) => FoodItemTile(
                data: _responseList[index],
              ),
            ),
    );
  }
}
