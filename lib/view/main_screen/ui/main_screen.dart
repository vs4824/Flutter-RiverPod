import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../common_widgets/image_assets.dart';
import '../../../provider/food_main_page_provider.dart';
import '../../../provider/home_page_provider.dart';
import '../../../provider/restaurant_list_provider.dart';
import '../../../provider/restaurant_screen_provider.dart';
import '../../../repository/homepage_repo.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/util.dart';
import '../../food_main_screen/ui/food_main_screen.dart';
import '../../main_search_screen/ui/main_screen_search.dart';
import '../widget/header_widget.dart';
import '../widget/offer_banner_widget.dart';
import '../widget/search_box_widget.dart';


class MainScreens extends ConsumerWidget {
  final Position? position;

   MainScreens({Key? key,this.position}) : super(key: key);

  final PageController _pageController = PageController(initialPage: 0);
   int dotIndex = 0;

   List<Map> gradientColors = [
     {
       "color": [
         const Color(0xFFF5CA44),
         const Color(0xFFF87726),
       ]
     },
     {
       "color": [
         const Color(0xFFBCBB4E),
         const Color(0xFF418762),
       ]
     },
     {
       "color": [
         const Color(0xFF6dd5ed),
         const Color(0xFF2193b0),
       ]
     },
     {
       "color": [
         const Color(0xFF734b6d),
         const Color(0xFF42275a),
       ]
     },
     {
       "color": [
         const Color(0xFFffb88c),
         const Color(0xFFde6262),
       ]
     },
   ];

   final Map _gradientColors = {
     "Food": [
       const Color(0xFFF5CA44),
       const Color(0xFFF87726),
     ],
     "Grocery": [
       const Color(0xFFBCBB4E),
       const Color(0xFF418762),
     ],
     "Meat": [
       const Color(0xFFffb88c),
       const Color(0xFFde6262),
     ],
   };

   List<Widget> buildDotIndicatorWidget(int length) {
     List<Widget> list = [];
     for (int i = 0; i < length; i++) {
       list.add(
         Container(
           margin: const EdgeInsets.symmetric(
             horizontal: 1,
             vertical: 7,
           ),
           height: 3,
           width: 3,
           decoration: BoxDecoration(
             color: i == dotIndex
                 ? Colors.white
                 : Colors.grey[200]!.withOpacity(0.3),
             shape: BoxShape.circle,
           ),
         ),
       );
     }
     return list;
   }

   List images = [
     'assets/images/food-removebg-preview.png',
     'assets/images/food-removebg-preview.png',
     'assets/images/grocery-removebg-preview.png',
     'assets/images/grocery-removebg-preview.png',
     'assets/images/grocery-removebg-preview.png',
     'assets/images/grocery-removebg-preview.png',
   ];

   List colors = [
     const Color(0xffFF9F8B),
     const Color(0xffFFE28B),
     const Color(0xff77DEC0),
     const Color(0xff77DEC0),
     const Color(0xffFF9F8B),
     const Color(0xffFFE28B),
   ];

  @override
  Widget build(BuildContext context, ref) {
    // ref.read(idProvider.notifier).state = "";
    final data1 = ref.watch(categoryNotifierProvider);
    final data2 = ref.watch(offersNotifierProvider);
    final data3 = ref.watch(orderProgressNotifierProvider);


    return Scaffold(
      body: data1.isEmpty != true && data2.isEmpty != true && data3.isEmpty != true ? SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                // data1.clear();
                HomePageAPIService.foodCategory();
              },
              child: ListView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  const SizedBox(height: 20),
                  HeaderWidget(position: position,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreenSearch(
                        categoryList: data1,
                      )));
                    },
                    child: const SearchBoxWidget(
                      enabled: false,
                      hintText: 'Search for food, grocery or more',
                      margin: EdgeInsets.only(top: 15, bottom: 20),
                      backgroundColor: Color(0xffF5F7FB),
                    ),
                  ),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount:
                    data1.length <
                        gradientColors.length
                        ? data1.length
                        : gradientColors.length,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () async {
                          ref.read(fetchIdProvider.notifier).state = data1[index].sId.toString();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FoodMainScreen(id: data1[index].sId.toString())));
                          // storeTypeId = data1["data"]["items"][index]["_id"];
                          // await PersistentNavBarNavigator
                          //     .pushNewScreen(
                          //   context,
                          //   screen: const MyFoodMainScreen(),
                          //   withNavBar: false,
                          // );

                          // controller.fetchMainScreenData();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (_) => FoodMainScreen(
                          //         id: _categoryResponseList[index]["_id"]),
                          //   ),
                          // );
                        },
                        child: CategoryBoxWidget(
                          image: images[index],
                          title: data1[index].storeType ?? "",
                          color: colors[index],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  data2.isEmpty ? const _EmptyOffersWidget()
                  : ListView.separated(
        physics:
        const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:
        data2.length,
        itemBuilder: (c, i) {
          return GestureDetector(
              onTap: () async {
                if (kDebugMode) {
                  print(data2[i].vendorstores?.length);
                }
                // if (data2["data"]["offer"][i]["vendorstores"].length >
                //     1) {
                //   await PersistentNavBarNavigator
                //       .pushNewScreen(
                //     context,
                //     screen: OfferRestaurantList(
                //       stores: data2["data"]["offer"][i]
                //       ["vendorstores"],
                //     ),
                //     withNavBar: false,
                //   );
                //   mainScreenController
                //       .fetchOffersNOrderProgressList();
                // }
                // else {
                //   await PersistentNavBarNavigator
                //       .pushNewScreen(
                //     context,
                //     screen: RestaurantScreen(
                //       data: data2["data"]["offer"][i]
                //       ["vendorstores"][0],
                //       isFavorite: data2["data"]["offer"][
                //       i]["vendorstores"][0]
                //       ["favourite"],
                //     ),
                //     withNavBar: false,
                //   );
                //   mainScreenController
                //       .fetchOffersNOrderProgressList();
                // }
              },
              child: OfferBannerWidget(
                category:
                data2[i].storeTypeId!.storeType.toString(),
                perc: data2[i].offerType ==
                    "Flat"
                    ? "Flat\nSAR ${data2[i].offerAmount} OFF"
                    : "Up to\n${data2[i].offerAmount}% OFF",
                tagline:
                "${data2[i].description}",
                gradient: _gradientColors[
                data2[i].storeTypeId!.storeType.toString()],
              ),
          );
        },
        separatorBuilder: (_, __) =>
        const SizedBox(height: 18),
      ),
                  SizedBox(
                    height: data3.isNotEmpty
                        ? 85
                        : 20,
                  )
                ],
              ),
            ),
            data3.isNotEmpty
                ? Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 65,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (value) {
                        // setState(() {
                        //   dotIndex = value;
                        // });
                      },
                      itemCount:
                      data3.length,
                      itemBuilder: (context, index) {
                        var data =
                        data3[index];
                        return InkWell(
                          onTap: () async {
                            // PersistentNavBarNavigator
                            //     .pushNewScreen(
                            //   context,
                            //   screen: OrderSummary(
                            //     id: data["_id"],
                            //     distance: data["distance"]
                            //         .toStringAsFixed(2),
                            //     isRated: false,
                            //     rating: "",
                            //     review: "",
                            //   ),
                            //   withNavBar: false,
                            // );
                          },
                          child: Container(
                            color: kAccentColor,
                            height: 65,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "View Order In Progress",
                                      style: mediumBoldTextStyle
                                          .copyWith(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Pick-up at ${dateTimeToDateStringFormat(data3[index].pickupDateTime.toString())} | ${dateTimeToTimeStringFormat(data3[index].pickupDateTime.toString())}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                arrowForwardIcon,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    if (data3.length > 1)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: buildDotIndicatorWidget(
                              data3.length),
                        ),
                      )
                  ],
                ),
              ),
            )
                : const SizedBox.shrink()
          ],
        ),
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _EmptyOffersWidget extends StatelessWidget {
  const _EmptyOffersWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage("assets/images/offerssale.png"),
          height: 220,
          width: 220,
        ),
        Text(
          "No offers in your display",
          style: const TextStyle(fontFamily: 'Montserrat-Medium').copyWith(
            fontSize: 16,
            color: const Color(0xff13253E),
          ),
        ),
      ],
    );
  }
}

class CategoryBoxWidget extends StatelessWidget {
  final String image, title;
  final Color color;

  const CategoryBoxWidget({
    Key? key,
    required this.image,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          Image.asset(
            image,
            height: 90,
          ),
          Container(
            width: 85,
            height: 35,
            color: Colors.transparent,
            alignment: Alignment.topCenter,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: Color(0xFF4A4123),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
