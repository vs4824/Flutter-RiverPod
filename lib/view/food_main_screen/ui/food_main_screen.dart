import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_examples/provider/food_main_page_provider.dart';
import 'package:riverpod_examples/view/food_main_screen/ui/foodMainScreen_restaurant_list.dart';
import 'package:riverpod_examples/view/food_main_screen/widgets/category_grid.dart';
import 'package:riverpod_examples/view/food_main_screen/widgets/rectangle_offer_image.dart';
import 'package:riverpod_examples/view/main_search_screen/ui/main_screen_search.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../../../common_widgets/shimmer_loading.dart';
import '../../../common_widgets/skelton_widget.dart';
import '../../../model_class/food_mainpage_models/food_offers_model.dart';
import '../../../utils/colors.dart';
import '../../main_screen/widget/header_widget.dart';
import '../../main_screen/widget/search_box_widget.dart';
import '../../offer_restaurant_list/ui/offers_restaurant_list.dart';
import '../../restaurant_screen/ui/restaurant_screen.dart';
import '../../search_screen/ui/search_screen.dart';


class FoodMainScreen extends ConsumerWidget {
  final String? id;

  FoodMainScreen({Key? key,this.id}) : super(key: key);

  String filterItem = "";
  String demoRadio = '';
  String demoMenu = "";
  dynamic _offerListResponse = [];
  bool isFetchingData = true, isLoading = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState");
    switch (state) {
      case AppLifecycleState.resumed:
        print("resumed");
        // Handle this case
        break;
      case AppLifecycleState.inactive:
        print("inactive");
        // Handle this case
        break;
      case AppLifecycleState.paused:
        print("paused");
        // Handle this case
        break;

      case AppLifecycleState.detached:
        print("detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final foodOffersData = ref.watch(foodOffersNotifierProvider);
    final foodCategoryData = ref.watch(foodCategoryNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: foodCategoryData.isEmpty
            ? const _LoadingScreen()
            : Stack(
          children: [
            ListView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderWidget(),
                      GestureDetector(
                        onTap: () {
                          // PersistentNavBarNavigator.pushNewScreen(
                          //   context,
                          //   screen: const SearchScreen(),
                          //   withNavBar: false,
                          // );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => SearchScreen(id: id)),
                          );
                        },
                        child: const SearchBoxWidget(
                          enabled: false,
                          hintText:
                          'Search for restaurant, items or more',
                          margin: EdgeInsets.only(top: 15, bottom: 20),
                          backgroundColor: Color(0xffF5F7FB),
                        ),
                      ),
                    ],
                  ),
                ),
                //OFFERS LIST
                if (foodOffersData.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'Get it quickly',
                          style: TextStyle(
                            color: kBlackTextColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                      SizedBox(
                          height: 145,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18),
                            children: offersList(data: foodOffersData,
                            context: context),
                          )

                        // ListView.builder(
                        //   scrollDirection: Axis.horizontal,
                        //   padding: const EdgeInsets.symmetric(horizontal: 18),
                        //   itemCount: _offerListResponse.length,
                        //   itemBuilder: (_, index) => RectangleOfferImage(
                        //     image: _offerListResponse[index]["image"] ?? "",
                        //     offer: _offerListResponse[index]["offer_amount"]
                        //             .toString() ??
                        //         "",
                        //     offerType: _offerListResponse[index]
                        //         ["offer_type"],
                        //     restaurantText: _offerListResponse[index]
                        //                 ["storeId"]
                        //             .isNotEmpty
                        //         ? _offerListResponse[index]["storeId"][0]
                        //             ["branchName"]
                        //         : "",
                        //     uptoValue: _offerListResponse[index]
                        //             ["upto_Amount"]
                        //         .toString(),
                        //   ),
                        // ),

                      ),
                    ],
                  ),
                //CATEGORY GRID LIST
                if (foodCategoryData.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'What’s on your mind',
                          style: TextStyle(
                            color: kBlackTextColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CategoryGrid(
                        data: foodCategoryData,
                        funcCallback: () {
                          print("food main screeeen callback");
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                RestaurantList(),
              ],
            ),
            Visibility(
              visible: isLoading,
              child: Scaffold(
                backgroundColor: Colors.grey[200]!.withOpacity(0.2),
                body: const Center(
                  child: LoadingIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> offersList({required List<FoodOffersModel> data, required BuildContext context}) {
    List<Widget> list = [];

    for (var offer in data) {
      list.add(
        GestureDetector(
          onTap: () {
            if (offer.vendorstores!.length > 1) {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  OfferRestaurantList(
                    // lat: locationController.lat
                    //     .toString(),
                    // long: locationController.long
                    //     .toString(),
                    stores: offer.vendorstores!,
                  )));
            } else {

              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  RestaurantScreen(
                    vendorOffer: offer.vendorstores![0],
                    isFavorite: offer.vendorstores![0].favourite!,
                  )));
            }
          },
          child: RectangleOfferImage(
            image: offer.image.toString(),
            offer: offer.offerAmount.toString() ?? "",
            uptoValue: offer.minimumAmount!.toStringAsFixed(2),
            offerType: offer.offerType.toString(),
          ),
        ),
      );
    }

    return list;
  }

  // void fetchOffersWithRestaurant(String storeId) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var response = await NetworkApi.getResponse(
  //     url:
  //         "${getRestaurantWithOffersUrl}lat=${locationController.lat}&lng=${locationController.long}&storeId=$storeId",
  //     headers: headersMap,
  //   );

  //   if (response["code"] == 401) {
  //     showSnackbar(
  //       context: context,
  //       title: response["message"],
  //       duration: const Duration(seconds: 4),
  //     );
  //     Get.find<CartController>().clearAllData();
  //     final prefs = await SharedPreferences.getInstance();
  //     if (await prefs.clear() && mounted) {
  //       Navigator.of(
  //         context,
  //         rootNavigator: true,
  //       ).pushAndRemoveUntil(
  //         MaterialPageRoute(
  //           builder: (_) => const LoginScreen(),
  //         ),
  //         (route) => false,
  //       );
  //     }
  //     return;
  //   }

  //   if (response["code"] != 200) {
  //     showSnackbar(
  //       context: context,
  //       title: response["message"],
  //     );
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return;
  //   }

  //   setState(() {
  //     isLoading = false;
  //   });

  //   if (mounted) {
  //     PersistentNavBarNavigator.pushNewScreen(
  //       context,
  //       screen: RestaurantScreen(
  //         data: response["data"]["categegoryItems"][0],
  //         isFavorite: response["data"]["categegoryItems"][0]["favourite"],
  //       ),
  //       withNavBar: false,
  //     );
  //   }
  // }

  var filterList = [
    'Sort',
    'Cuisines',
    'Ratings',
    'Veg/Non-Veg',
  ];

  var menuList = [
    'Relevance (Default)',
    'Rating',
    'Cost: Low to High',
    'Cost: High to Low',
  ];

  var list = [
    'Relevance (Default)',
    'Rating',
    'Cost: Low to High',
    'Cost: High to Low',
    'Sort',
    'Cuisines',
    'Ratings',
    'Veg/Non-Veg',
  ];
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Skelton(
                    width: 150,
                  ),
                  const SizedBox(height: 5),
                  const Skelton(
                    height: 40,
                  ),
                  const SizedBox(height: 10),
                  const Skelton(
                    width: 130,
                  ),
                  const SizedBox(height: 5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      children: const [
                        Skelton(
                          height: 140,
                          width: 120,
                        ),
                        SizedBox(width: 10),
                        Skelton(
                          height: 140,
                          width: 120,
                        ),
                        SizedBox(width: 10),
                        Skelton(
                          height: 140,
                          width: 120,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Skelton(width: 140),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 4; i++)
                        const Skelton(
                          height: 60,
                          width: 60,
                        ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 4; i++)
                        const Skelton(
                          height: 60,
                          width: 60,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Skelton(width: 140),
                  const SizedBox(height: 8),
                  const Skelton(height: 120),
                  const SizedBox(height: 10),
                  const Skelton(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
