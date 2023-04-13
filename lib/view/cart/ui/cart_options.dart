import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widgets/bottom_bar_widget.dart';
import '../../../common_widgets/dark_text_row_widget.dart';
import '../../../common_widgets/dashed_line.dart';
import '../../../common_widgets/light_text_row_widget.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../../../common_widgets/network_api.dart';
import '../../../common_widgets/pickup_time_screen.dart';
import '../../../controller/cart_controller.dart';
import '../../../model_class/food_mainpage_models/restaurant_list_model.dart';
import '../../../model_class/item_model/item_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/shared_pref_keys.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/util.dart';
import '../../main_screen/widget/search_box_widget.dart';
import '../../restaurant_screen/widgets/veg_indicator_widget.dart';


class StoreCart extends StatefulWidget {
  final RestaurantListModel? detail;
  final Function? func;

  const StoreCart({
    super.key,
    required this.detail,
    this.func,
  });

  @override
  State<StoreCart> createState() => _StoreCartState();
}

class _StoreCartState extends State<StoreCart> {
  dynamic _response;
  bool isLoading = true;
  String offerString = "";
  final CartController cartController = CartController();
  final TextEditingController textController = TextEditingController();
  // double tax = 0, amountToPay = 0;

  // @override
  // void initState() {
  //   initializeCart();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // if (CartController().itemsList.isEmpty && mounted) {
    //   // isTrue = true;
    //   WidgetsBinding.instance
    //       .addPostFrameCallback((timeStamp) async {
    //     await Future.delayed(
    //       const Duration(milliseconds: 100),
    //       // () {
    //       //   if (mounted && isTrue) {
    //       //     isTrue = false;
    //       //     print("pop out");
    //       //     Navigator.of(context).pop(true);
    //       //   }
    //       // },
    //     );
    //     if (mounted) {
    //       // isTrue = false;
    //       print("pop out");
    //       Navigator.pop(context);
    //     }
    //   });
    // }
    if (CartController().isCouponApplied) {
      return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        padding: const EdgeInsets.only(left: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border:
          Border.all(color: kBoxBorderColor),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CartController().couponCode,
              style: const TextStyle(
                color: kBlackTextColor,
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () {
                textController.clear();
                CartController().clearOffer();
                CartController().calculateAmount();
              },
              child: const Text(
                "REMOVE",
                style: TextStyle(
                  color: kCancelledColor,
                ),
              ),
            )
          ],
        ),
      );
    }
    if (cartController.discount != 0) {
      return Column(
        children: [
          const MySeparator(
            color: kBoxBorderColor,
          ),
          LightTextRow(
            text: 'Item Discount',
            price:
            'SAR ${cartController.discount.toStringAsFixed(2)}',
          ),
        ],
      );
    }

    return WillPopScope(
      onWillPop: () async {
        cartController.clearOffer();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kScaffoldBackgroundColor,
          leading: IconButton(
            onPressed: () {
              cartController.clearOffer();
              Navigator.of(context).pop();
            },
            icon: const Image(
              image: AssetImage('assets/images/arrowleftblack.png'),
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: kScaffoldBackgroundColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            // bottom: 10,
                          ),
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              widget.detail!.branchName.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: kBlackTextColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 0),
                      ],
                    ),
                  ),
                  //CART ITEMS LIST
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: CartController().itemsList.length,
                    itemBuilder: (context, index) {
                      var item = CartController().itemsList[index];
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VegIndicatorWidget(
                                isVeg: item.foodCatTitle == "Veg"),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.itemName ?? "",
                                  style: mediumBoldTextStyle,
                                ),
                                Text(
                                  'SAR ${item.itemPrice}',
                                  style: mediumBoldTextStyle.copyWith(
                                      color: kAccentColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.itemSizeName ?? "",
                              style: lightTextStyle.copyWith(
                                color: kLightestTextColor,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 3),
                            if (item.addons?.isNotEmpty ?? false)
                              Row(
                                children: [
                                  for (int i = 0;
                                  i < item.addons!.length;
                                  i++)
                                    Text(
                                      i != item.addons!.length - 1
                                          ? "${item.addons![i].addonsName}, "
                                          : "${item.addons![i].addonsName}",
                                      overflow: TextOverflow.ellipsis,
                                      style: lightTextStyle.copyWith(
                                        color: kLightestTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment:
                              CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                // InkWell(
                                //   onTap: () {
                                //     showCustomizeBottomSheet(context);
                                //   },
                                //   child: Row(
                                //     children: const [
                                //       Text(
                                //         'Customize',
                                //         style: TextStyle(
                                //           color: kLightTextColor,
                                //           fontSize: 13,
                                //         ),
                                //       ),
                                //       Icon(
                                //         Icons.keyboard_arrow_down_rounded,
                                //         size: 20,
                                //         color: kLightestTextColor,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                CounterWidget(
                                  item: item,
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: 0,
                      color: kBoxBorderColor,
                    ),
                  ),
                  //COUPONS BOX
                  DecoratedBox(
                    decoration:
                        const BoxDecoration(color: kScaffoldBackgroundColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 17,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Offers & Benefits',
                                style: TextStyle(color: kBlackTextColor),
                              ),
                              SearchBoxWidget(
                                controller: textController,
                                margin: const EdgeInsets.only(
                                  top: 10,
                                ),
                                hintText: "Enter Coupon Code",
                                hintStyle: lightTextStyle.copyWith(
                                  color: kLightestTextColor,
                                  fontSize: 13,
                                ),
                                border: Border.all(color: kBoxBorderColor),
                                onChanged: (value) {
                                  // offerString = value;
                                  CartController().setOfferText(value);
                                },
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    if (textController.text.isEmpty) {
                                      return;
                                    }
                                    checkAppliedOffer(textController.text);
                                  },
                                  style: ButtonStyle(
                                    overlayColor:
                                    MaterialStateColor.resolveWith(
                                          (states) => textController
                                          .text.isNotEmpty
                                          ? kAccentColor.withOpacity(0.1)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  child: Text(
                                    "APPLY",
                                    style: TextStyle(
                                      color: textController.text.isNotEmpty
                                          ? kBlackTextColor
                                          : kLightestTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0),
                      ],
                    ),
                  ),
                  //BILL AMOUNT DETAILS
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bill Details',
                          style: mediumBoldTextStyle.copyWith(
                            color: kBlackTextColor,
                            fontSize: 16,
                          ),
                        ),
                        DarkTextRow(
                          title: 'Item Total',
                          price:
                          'SAR ${(cartController.subTotal).toStringAsFixed(2)}',
                        ),
                        const SizedBox.shrink(),
                        const MySeparator(
                          color: kBoxBorderColor,
                        ),
                        LightTextRow(
                          text: 'Taxes and Charges',
                          price:
                          'SAR ${CartController().taxAmount.toStringAsFixed(2)}',
                        ),
                        const MySeparator(
                          color: kBoxBorderColor,
                        ),
                        DarkTextRow(
                          title: 'To Pay',
                          price:
                          'SAR ${CartController().amountToPay.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isLoading,
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
        ),
        bottomNavigationBar: isLoading
            ? null
            : BottomBarWidget(
          title: 'SAR ${CartController().amountToPay.toStringAsFixed(2)}',
          subtitle: 'Grand Total',
          btnText: 'Proceed to pay',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PickupTimeScreen(
                  detail: widget.detail,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void checkAppliedOffer(String couponCode) async {
    print(couponCode);
    var response = await NetworkApi.getResponse(
      url:
          "offer/checkOffer?couponCode=$couponCode&storeId=${cartController.storeId}&totalAmount=${cartController.subTotal}",
      headers: {
        "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
        "deviceType": "iOS",
        "timezone": "Asia/Kolkata",
        "language": "en",
        "currentVersion": "16.2",
        "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk"
      },
    );
    log(jsonEncode(response));
    if (response["code"] == 401) {
      showSnackbar(
        context: context,
        title: response["message"],
        duration: const Duration(seconds: 4),
      );
      cartController.clearAllData();
      final prefs = await SharedPreferences.getInstance();
      // if (await prefs.clear() && mounted) {
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (_) => const LoginScreen(),
      //     ),
      //     (route) => false,
      //   );
      // }
      return;
    }
    if (response["code"] != 200) {
      showSnackbar(
        context: context,
        title: response["message"],
      );
      return;
    }
    if (response["code"] == 200) {
      cartController.clearOffer();
      showSnackbar(
        context: context,
        title: response["message"],
      );
      cartController.setOffer(
        isCouponApplied: true,
        couponCode: response["data"]["couponCode"],
        offerType: response["data"]["offer_type"],
        offerAmount: response["data"]["offer_amount"],
        uptoAmount: response["data"]["upto_Amount"],
        minimumOrderAmount: response["data"]["minimum_amount"],
      );
      cartController.calculateAmount();
    }
  }
}

class CounterWidget extends StatefulWidget {
  final Items item;

  // final void Function()? calcAmount;
  const CounterWidget({
    Key? key,

    // this.calcAmount,
    required this.item,
  }) : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int counter = 1;
  int index = 0;
  String orderId = "";
  final CartController cartController = CartController();

  void ok() {
    setState(() {
      index = cartController.itemsList.indexOf(widget.item);
      counter = cartController.itemsList[index].quantity ?? 1;
    });
  }

  @override
  void initState() {
    super.initState();
    // ok();
  }

  @override
  Widget build(BuildContext context) {
    orderId = cartController.orderId;
    index = cartController.itemsList.indexOf(widget.item);
    counter = cartController.itemsList[index].quantity ?? 1;
    String quantity =
    (cartController.itemsList[index].quantity ?? 1).toString();

    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      decoration: const BoxDecoration(
        color: kAccentColor,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () async {
              print('minus');

              if (counter > 1) {
                setState(() {
                  counter = counter - 1;
                });
                cartController.updateItemAtIndex(
                  widget.item,
                  index,
                  counter,
                );
                cartController.calculateAmount();
              } else {
                if (cartController.itemsList.isEmpty) {
                  await removeCartFromApi();
                }
                cartController.deleteItemAtIndex(index);
                cartController.calculateAmount();
              }
            },
            child: const Icon(
              Icons.remove,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              print(counter);
            },
            child: Text(
              quantity,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              print('plus');

              setState(() {
                counter = counter + 1;
              });

              cartController.updateItemAtIndex(
                widget.item,
                index,
                counter,
              );
              cartController.calculateAmount();
              // widget.calcAmount!();
              // widget.func!();
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> removeCartFromApi() async {
    print(orderId);
    var response = await NetworkApi.getResponse(
      url: "order/removeCart/$orderId",
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
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (_) => const LoginScreen(),
      //     ),
      //     (route) => false,
      //   );
      // }
      return;
    }

    if (response["code"] != 200) {
      print("error in remove cart api");
      if (mounted) {
        showSnackbar(
          context: context,
          title: response["message"],
        );
      }
      return;
    }

    print("removed cart successfully");
  }
}



// Padding(
//   padding: const EdgeInsets.all(18.0),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const VegIndicatorWidget(isVeg: true),
//       const SizedBox(height: 8),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'Awadhi Veg Biryani',
//             style: mediumBoldTextStyle,
//           ),
//           Text(
//             'SAR 120',
//             style:
//                 mediumBoldTextStyle.copyWith(color: kAccentColor),
//           )
//         ],
//       ),
//       const SizedBox(height: 2),
//       Text(
//         'Half',
//         style: lightTextStyle.copyWith(
//           color: kLightestTextColor,
//           fontSize: 12,
//         ),
//       ),
//       const SizedBox(height: 3),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.baseline,
//         textBaseline: TextBaseline.alphabetic,
//         children: [
//           InkWell(
//             onTap: () {
//               showCustomizeBottomSheet(context);
//             },
//             child: Row(
//               children: const [
//                 Text(
//                   'Customize',
//                   style: TextStyle(
//                     color: kLightTextColor,
//                     fontSize: 13,
//                   ),
//                 ),
//                 Icon(
//                   Icons.keyboard_arrow_down_rounded,
//                   size: 20,
//                   color: kLightestTextColor,
//                 ),
//               ],
//             ),
//           ),
//           // Container(
//           //   // margin: margin,
//           //   padding: const EdgeInsets.symmetric(
//           //     horizontal: 5,
//           //     vertical: 5,
//           //   ),
//           //   decoration: const BoxDecoration(
//           //     color: kAccentColor,
//           //     borderRadius: BorderRadius.all(Radius.circular(4)),
//           //   ),
//           //   child: Row(
//           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //     children: [
//           //       InkWell(
//           //         onTap: () {
//           //           print('minus');
//           //         },
//           //         child: const Icon(
//           //           Icons.remove,
//           //           color: Colors.white,
//           //           size: 20,
//           //         ),
//           //       ),
//           //       const SizedBox(width: 10),
//           //       const Text(
//           //         '2',
//           //         style: TextStyle(
//           //           color: Colors.white,
//           //           fontSize: 15,
//           //         ),
//           //       ),
//           //       const SizedBox(width: 10),
//           //       InkWell(
//           //         onTap: () {
//           //           print('plus');
//           //         },
//           //         child: const Icon(
//           //           Icons.add,
//           //           color: Colors.white,
//           //           size: 20,
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           PlusMinusCounterWidget(
//             margin: EdgeInsets.zero,
//           ),
//         ],
//       )
//     ],
//   ),
// ),
