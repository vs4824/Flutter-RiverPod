import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_examples/common_widgets/star_rating_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model_class/food_mainpage_models/restaurant_list_model.dart';
import '../provider/restaurant_screen_provider.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/util.dart';
import '../view/restaurant_screen/ui/restaurant_screen.dart';
import 'image_assets.dart';
import 'network_api.dart';
import 'rounded_image_widget.dart';

class FoodItemTile extends StatefulWidget {
  final RestaurantListModel  data;
  final Function()? func;
  const FoodItemTile({
    Key? key,
    required this.data,
    this.func,
  }) : super(key: key);

  @override
  State<FoodItemTile> createState() => _FoodItemTileState();
}

class _FoodItemTileState extends State<FoodItemTile> {
  late bool _isFav;

  @override
  void initState() {
    _isFav = widget.data.favourite!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return GestureDetector(
          onTap: () async {
            ref.read(idProvider.notifier).state = widget.data.sId!;
            ref.read(idsProvider.notifier).state = widget.data.sId!;
            ref.read(vegNonVegIdProvider.notifier).state = "";

            // if (widget.data.containsKey("item")) {
            //   if (!(widget.data &&
            //       widget.data["near_Restaurant"] &&
            //       widget.data["item"])) {
            //     showSnackbar(
            //       context: context,
            //       title: "This restaurant is not available",
            //     );
            //     return;
            //   }
            // }

            var isFav = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                RestaurantScreen(
                  data: widget.data,
                  isFavorite: _isFav,
                )));

            if (isFav != _isFav) {
              setState(() {
                _isFav = isFav;
              });
            }

            if (widget.func != null) {
              widget.func!();
            }

            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) => RestaurantScreen(
            //       data: widget.data,
            //       isFavorite: _isFav,
            //     ),
            //   ),
            // );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 18, bottom: 18),
            padding:
            const EdgeInsets.only(left: 18, top: 18, bottom: 18, right: 10),
            decoration: BoxDecoration(
              border: Border.all(color: kBoxBorderColor),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                RoundedImageWidget(
                  image: widget.data.image.toString(),
                  height: 120,
                  width: 98,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StarRatingWidget(
                            rating: widget.data.rating.toStringAsFixed(1),
                          ),
                          //FAVORITES ICON
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _isFav = !_isFav;
                              });

                              try {
                                var response = await NetworkApi.getResponse(
                                    url:
                                    "fav/addFavorite?storeId=${widget.data.sId}&vendorId=${widget.data.vendorId}",
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
                                print(response);

                                if (response != null) {
                                  if (response["data"]["message"] == "success") {
                                    if (widget.func != null) {
                                      widget.func!();
                                    }

                                    return;
                                  }
                                } else {
                                  showSnackbar(
                                    context: context,
                                    title: "Some error occurred",
                                  );
                                  setState(() {
                                    _isFav = !_isFav;
                                  });
                                }
                              } catch (e) {}
                            },
                            child: Icon(
                              _isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 24,
                              color: kFavoriteColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.data.branchName!,
                        style: mediumBoldTextStyle.copyWith(
                          fontSize: 16,
                          color: kBlackTextColor,
                        ),
                      ),
                      const SizedBox(height: 1),
                      if (widget.data.cuisinee!.isNotEmpty)
                        SizedBox(
                          width: 190,
                          child: Wrap(
                            children: buildCuisineeListWidget(
                              widget.data.cuisinee!,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              locationIcon,
                              const SizedBox(width: 3),
                              (widget.data.offer != null)
                                  ? Text(
                                widget.data.fullAddress!.length < 12
                                    ? "${widget.data.fullAddress}"
                                    : "${widget.data.fullAddress!.substring(0, 9)}...",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: kLightTextColor,
                                ),
                              )
                                  : Text(
                                widget.data.fullAddress!.length < 12
                                    ? "${widget.data.fullAddress}"
                                    : "${widget.data.fullAddress!.substring(0, 19)}...",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: kLightTextColor,
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  ' | ${widget.data.dictance?.toStringAsFixed(2)} km',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kLightTextColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          if (widget.data.offer != null &&
                              widget.data.offer!.offerType ==
                                  "Percentage") //${widget.data["offer"]["offer_percentage"]}
                            Row(
                              children: [
                                offersIcon,
                                const SizedBox(width: 2),
                                Text(
                                  '${widget.data.offer!.offerAmount!.toStringAsFixed(1)}% OFF',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kAccentColor,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> buildCuisineeListWidget(List<Cuisinee>? cuisineList) {
    List<Widget> list = [];
    List<Cuisinee>? parseList = [];
    for (var item in cuisineList!) {
      if (parseList.length < 3) {
        if (item.isActive!) {
          parseList.add(item);
        }
      } else {
        break;
      }
    }
    for (int i = 0; i < parseList.length; i++) {
      list.add(
        Text(
          (i == parseList.length - 1)
              ? "${parseList[i].title}"
              : "${parseList[i].title} | ",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: lightTextStyle.copyWith(
            fontSize: 12,
            color: kLightestTextColor,
          ),
        ),
      );
    }
    return list;
  }
}
