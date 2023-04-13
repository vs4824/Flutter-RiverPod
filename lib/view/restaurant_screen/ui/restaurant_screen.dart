import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_examples/model_class/cart_model.dart';
import 'package:riverpod_examples/view/restaurant_screen/widgets/veg_indicator_widget.dart';
import 'package:riverpod_examples/view/restaurant_screen/widgets/veg_nonveg_widget.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widgets/backArrowAppBar.dart';
import '../../../common_widgets/bottom_bar_widget.dart';
import '../../../common_widgets/expandable_text_widget.dart';
import '../../../common_widgets/image_assets.dart';
import '../../../common_widgets/network_api.dart';
import '../../../common_widgets/plusMinus_counter_widget.dart';
import '../../../common_widgets/rounded_image_widget.dart';
import '../../../common_widgets/shimmer_loading.dart';
import '../../../common_widgets/skelton_widget.dart';
import '../../../common_widgets/star_rating_widget.dart';
import '../../../common_widgets/yellow_btn_widget.dart';
import '../../../controller/cart_controller.dart';
import '../../../model_class/addon_model/addons_model.dart';
import '../../../model_class/food_mainpage_models/food_offers_model.dart';
import '../../../model_class/food_mainpage_models/restaurant_list_model.dart' as restaurant_list_model;
import '../../../model_class/food_mainpage_models/restaurant_list_model.dart';
import '../../../model_class/item_model/item_model.dart';
import '../../../model_class/restaurants_models/fetch_offers_model.dart';
import '../../../model_class/restaurants_models/veg_option_list_model.dart';
import '../../../provider/restaurant_screen_provider.dart';
import '../../../repository/restaurant_repo.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/util.dart';
import '../../cart/ui/cart_options.dart';
import '../../restaurant_search_screen/ui/restaurant_search.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final storeIdProvider = cartProvider.select((v) => v.storeId);
final discountProvider = cartProvider.select((v) => v.discount);
final itemsListProvider = cartProvider.select((v) => v.itemsList);
final clearAllDataProvider = cartProvider.select((v) => v.clearAllData);
final cartDataProvider = cartProvider.select((v) => v.cart);
final subTotalProvider = cartProvider.select((v) => v.subTotal);
final vendorIdProvider = cartProvider.select((v) => v.vendorId);
final saveDataToPrefsProvider = cartProvider.select((v) => v.saveDataToPrefs);
final addItemToCartProvider = cartProvider.select((v) => v.addItemToCart);
final addItemWithAddonToCartProvider = cartProvider.select((v) => v.addItemWithAddonToCart);



class RestaurantScreen extends ConsumerWidget {
  final RestaurantListModel? data;
  final bool isFavorite;
  final Function()? funcCallback;
  final Vendorstores? vendorOffer;
  RestaurantScreen({
    super.key,
    this.data,
    required this.isFavorite,
    this.vendorOffer,
    this.funcCallback,
  });


  late bool isFavorites;
  bool isAdded = false, _isRefreshing = false, _isResponseEmpty = false;
  bool isLoading = true;
  String foodCategoryId = "";
  String vegId = "", nonVegId = "";
  dynamic vegNonvegList = [];
  dynamic _response = [];
  dynamic offersResponseList = [];
  var orginalResponseArray;
  dynamic searchListArray = [];
  List menuBtnList = [];
  dynamic formattedResponse;
  late int scrollToIndex;

  late AutoScrollController autoScrollController = AutoScrollController();

  final ItemScrollController itemScrollController = ItemScrollController();

  void updateCart({required String storeId, required void Function() clearAllData, required List<Items> itemsList, required Cart cart}) {
    if (storeId == data!.sId &&
        itemsList.isNotEmpty) {
      if (parseMenuItems()) {
        print("parse menu item : true");
        if (!compareCartWtihMenuItems(storeId: storeId,cart: cart,
            clearAllData: clearAllData, itemsList: itemsList)) {
          clearAllData();
          print("is all matching : false");
          return;
        }
        print("is all matching : true");
      } else {
        print("parse menu item : false");
        clearAllData();
      }
    }
  }

  void updateCartItemDetails({required String storeId, required void Function() clearAllData, required List<Items> itemsList, required Cart cart}) {
    for (var cartItem in itemsList) {
      for (var element in orginalResponseArray['data']['array']) {
        for (var menuItem in element["menu_data"]) {
          if (cartItem.itemId == menuItem["_id"]) {
            cartItem.itemName = menuItem["itemName"];
            cartItem.foodCatId = menuItem["foodcategories"][0]["_id"];
            cartItem.foodCatTitle = menuItem["foodcategories"][0]["title"];

            num totalPrice = 0;

            if (cartItem.itemSize != null &&
                cartItem.itemSize!.isNotEmpty &&
                menuItem["item_size"]) {
              for (var menuItemSize in menuItem["vendor_itemsizes"]) {
                if (cartItem.itemSize == menuItemSize["_id"]) {
                  cartItem.itemSizeName = menuItemSize["item_size"];
                  totalPrice += menuItemSize["amount"];
                }
              }
            } else {
              totalPrice += menuItem["amount"];
            }

            if (cartItem.addons != null && cartItem.addons!.isNotEmpty) {
              for (var cartAddon in cartItem.addons!) {
                for (var element in menuItem["addons_list"]) {
                  for (var menuItemAddon in element["menu_data"]) {
                    if (cartAddon.addonsId == menuItemAddon["_id"]) {
                      cartAddon.addonsName = menuItemAddon["title"];
                      cartAddon.addonsPrice =
                          num.parse(menuItemAddon["amount"]);
                      cartAddon.perAddonsPrice =
                          num.parse(menuItemAddon["amount"]);
                      totalPrice += num.parse(menuItemAddon["amount"]);
                    }
                  }
                }
              }
            }

            cartItem.perItemPrice = totalPrice;
            cartItem.itemPrice = totalPrice * cartItem.quantity!;
          }
        }
      }
    }
    cart.items = itemsList;
  }

  void function1 ({required List<VegOptionList> data}){
    vegNonvegList = data;
    for (VegOptionList item in vegNonvegList) {
      if (item.title == "Veg") {
        vegId = item.sId!;
      } else if (item.title == "Non-veg") {
        nonVegId = item.sId!;
      }
    }
  }

  void function2 ({required Map<String, dynamic> data, required String storeId, required void Function() clearAllData, required List<Items> itemsList, required Cart cart, required String vendorId}){
    orginalResponseArray = data;
    log(json.encode(orginalResponseArray));

    if(orginalResponseArray.length > 0){
      if (orginalResponseArray["data"]["recommended"].isNotEmpty) {
        formattedResponse = {
          "data": {
            "array": [
              {
                "menu_data": orginalResponseArray["data"]["recommended"],
                "category": [
                  {
                    "title": "Recommended",
                  },
                ],
              },
            ],
          },
        };

        for (var item in orginalResponseArray["data"]["array"]) {
          formattedResponse["data"]["array"].add(item);
        }
        _response = formattedResponse["data"]["array"];
        for (int i = 0; i < _response.length; i++) {
          menuBtnList.add(
            {
              "menu_item": {
                "title": _response[i]["category"][0]["title"],
                "length": _response[i]["menu_data"].length,
                "scroll_index": i,
              }
            },
          );
        }
      }
      else {
        _response = orginalResponseArray["data"]["array"];
        for (int i = 0; i < _response.length; i++) {
          menuBtnList.add(
            {
              "menu_item": {
                "title": _response[i]["category"][0]["title"],
                "length": _response[i]["menu_data"].length,
                "scroll_index": i,
              }
            },
          );
        }
      }
      updateCart(storeId: storeId,
          clearAllData: clearAllData, itemsList: itemsList,cart: cart);

      _isResponseEmpty = _response.isEmpty;
      isLoading = false;
      updateCartItemDetails(storeId: storeId,cart: cart,
          clearAllData: clearAllData, itemsList: itemsList);
      parseSearchArray();
    }
  }

  bool parseMenuItems() {
    List menuItems = [];
    List cartItems = [];
    // for (var item in cartController.itemsList) {
    //   cartItems.add(item.itemId);
    // }
    for (var element in orginalResponseArray) {
      for (var menuItem in element["menu_data"]) {
        menuItems.add(menuItem["_id"]);
      }
    }
    if (cartItems.every((item) => menuItems.contains(item))) {
      return true;
    } else {
      return false;
    }
  }

  bool compareCartWtihMenuItems({required String storeId, required cart, required void Function() clearAllData, required List<Items> itemsList}) {
    var cartItemsList = itemsList;
    if (storeId == data!.sId) {
      bool doesAllItemsMatch = false;
      bool doesSizeMatch = true;
      bool doesAddonsMatch = true;
      for (var cartItem in cartItemsList) {
        for (var menuItem in orginalResponseArray) {
          for (var menuItem in menuItem["menu_data"]) {
            if (cartItem.itemId == menuItem["_id"]) {
              doesAllItemsMatch = true;
              if (cartItem.itemSize?.isNotEmpty ?? false) {
                if (menuItem["item_size"]) {
                  if (!(menuItem["vendor_itemsizes"]
                      .toString()
                      .contains(cartItem.itemSize!))) {
                    doesSizeMatch = false;
                    print("size not found");
                    return false; //false
                  }
                } else {
                  print("api does not contains size");
                  return false; //false
                }
              }

              if (cartItem.addonIdArray?.isNotEmpty ?? false) {
                if (menuItem["addons"]) {
                  for (var addon in cartItem.addonIdArray!) {
                    if (!(menuItem["addons_list"].toString().contains(addon))) {
                      doesAddonsMatch = false;
                      print("addons do not match");
                      return false; // false
                    }
                  }
                } else {
                  print("api does not contain addons");
                  return false; // false
                }
              }
            }
          }
        }
      }
      print(
          "end of loops doesAllItemsMatch : $doesAllItemsMatch, doesSizeMatch : $doesSizeMatch, doesAddonsMatch : $doesAddonsMatch");
      return doesAllItemsMatch && doesSizeMatch && doesAddonsMatch;
    } else {
      print("store id does not match");
      return false; // store id does not match
    }
  }

  void parseSearchArray() {
    for (var element in orginalResponseArray['data']['array']) {
      for (var item in element["menu_data"]) {
        searchListArray.add(item);
      }
    }
  }

  void callBack() {
    print("callback");

    // menuBtnList = [];
    // getAllData();
  }

  // @override
  // void initState() {
  //   isFavorites = isFavorite;
  //   autoScrollController = AutoScrollController(
  //     viewportBoundaryGetter: () =>
  //         Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
  //     axis: Axis.vertical,
  //   );
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context,ref) {
    var storeId = ref.watch(storeIdProvider);
    var discount = ref.watch(discountProvider);
    var itemsList = ref.watch(itemsListProvider);
    var clearAllData = ref.watch(clearAllDataProvider);
    var cart = ref.watch(cartDataProvider);
    var subTotal = ref.watch(subTotalProvider);
    var vendorId = ref.watch(vendorIdProvider);
    var saveDataToPrefs = ref.watch(saveDataToPrefsProvider);
    var addItemToCart = ref.watch(addItemToCartProvider);
    var addItemWithAddonToCart = ref.watch(addItemWithAddonToCartProvider);


    isFavorites = isFavorite;
    autoScrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(isFavorite);
        // widget.funcCallback!();
        return true;
      },
      child: Scaffold(
        appBar: backArrowAppBar(
          context: context,
          onBackPressed: () {
            Navigator.of(context).pop(isFavorite);
            // widget.funcCallback!();
          },
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RestaurantSearchScreen(
                      id: data!.sId!,
                      list: searchListArray,
                    ),
                  ),
                );

                // if (reload) {
                //   callBack();
                // }
              },
              child: Row(
                children: [
                  const Image(
                    image: AssetImage('assets/images/Search.png'),
                    color: Colors.black,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Search',
                    style:
                    lightTextStyle.copyWith(color: const Color(0xff13253E)),
                  ),
                  const SizedBox(width: 18),
                ],
              ),
            ),
          ],
        ),
        body: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final offerData = ref.watch(fetchOffersNotifierProvider);

            final vegOptionListData = ref.watch(fetchVegOptionListNotifierProvider);

            vegOptionListData.isNotEmpty ? function1(data: vegOptionListData)
                : print("");

            final menuListData = ref.watch(fetchMenuItemsNotifierProvider);

            menuListData != null ?  function2(data: menuListData,storeId: storeId,
            clearAllData: clearAllData, itemsList: itemsList,cart: cart,
            vendorId: vendorId)
                : print("");

            return vegOptionListData.isEmpty ? const _LoadingScreen(showBtn: false)
                : ListView(
              controller: autoScrollController,
              children: [
                //Restaurant name details
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
                              rating: data!.rating.toStringAsFixed(1),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 245,
                                  child: Text(
                                    data!.branchName!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: kBlackTextColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    //SHARE ICON
                                    IconButton(
                                      onPressed: () async {
                                        print("share plus");
                                        final urlImage = data!.image;
                                        final response =
                                        await http.get(Uri.parse(urlImage!));
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
                                    const SizedBox(width: 10),
                                    //FAVORITE ICON
                                    InkWell(
                                      onTap: () async {
                                        // setState(() {
                                          isFavorites = !isFavorite;
                                        // });
                                        print(
                                            "fav/addFavorite?storeId=${data!.sId}&vendorId=${data!.vendorId}");
                                        try {
                                          var response =
                                          await NetworkApi.getResponse(
                                              url:
                                              "fav/addFavorite?storeId=${data!.sId}&vendorId=${data!.vendorId}",
                                              headers: {
                                                "deviceToken": "flMK6MvHlkQjo0j7zIBM4q:APA91bEy-XfQzopRJjNafTG-4NAxG8UTjT4lixVUBwhbM_u7PqtF6x39I5Ktxqq8plM14l1ZQOTPu0pnhx5vBHLNSUFLBuUBYM0WPGIJAjF6YbY4PUxhWQEdMPdK01iLxzm7zSyVCWZo",
                                                "deviceType": "iOS",
                                                "timezone": "Asia/Kolkata",
                                                "language": "en",
                                                "currentVersion": "16.2",
                                                "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzY2VhMmZiNDUzNzZjYzg5N2U3Y2MzYSIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTY3OTQ2NDkwMSwiZXhwIjoxNjgyMDU2OTAxfQ.lMzbbjtVb7-u_SqksMgiN4vIRi2vW7cKxKJIPMabpvk"
                                              }
                                          );
                                          print(response);

                                          if (response["code"] == 401) {
                                            showSnackbar(
                                              context: context,
                                              title: response["message"],
                                              duration: const Duration(seconds: 4),
                                            );
                                            clearAllData;
                                            final prefs = await SharedPreferences
                                                .getInstance();
                                            if (await prefs.clear()) {
                                              // Navigator.of(
                                              //   context,
                                              //   rootNavigator: true,
                                              // ).pushAndRemoveUntil(
                                              //   MaterialPageRoute(
                                              //     builder: (_) =>
                                              //         const LoginScreen(),
                                              //   ),
                                              //   (route) => false,
                                              // );
                                            }
                                            return;
                                          }

                                          if (response != null) {
                                            if (response["data"]["message"] ==
                                                "success") {
                                              return;
                                            }
                                          } else {
                                            showSnackbar(
                                              context: context,
                                              title: "Some error occurred",
                                            );
                                            // setState(() {
                                              isFavorites = !isFavorite;
                                            // });
                                          }
                                        } catch (e) {
                                          print(e);
                                          // setState(() {
                                            isFavorites = !isFavorite;
                                          // });
                                        }
                                      },
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        color: kFavoriteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // const SizedBox(height: 4),
                            if (data!.cuisinee!.isNotEmpty)
                              SizedBox(
                                width: 300,
                                child: Wrap(
                                  children: buildCuisineeListWidget(
                                    data!.cuisinee!,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 12),
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
                                        "${data!.fullAddress}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                        const TextStyle(color: kLightTextColor),
                                      ),
                                    ),
                                    Text(
                                      ' | ${data!.dictance?.toStringAsFixed(2)} km',
                                      style:
                                      const TextStyle(color: kLightTextColor),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () async {
                                    print("redirect to maps");
                                    if (data!.lat != null &&
                                        data!.lng != null) {
                                      redirectToMaps(
                                        lat: data!.lat!,
                                        long: data!.lng!,
                                        title: data!.branchName!,
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
                // //Offer Box
                if (offerData.isNotEmpty)
                  OffersListWidget(offersResponseList: offerData),
                const SizedBox(height: 15),
                //Veg / Non-Veg row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: buildVegnonVegList(),
                  ),
                ),
                isLoading
                    ? const _LoadingScreen(showBtn: true)
                    : (_isRefreshing || _response.isNotEmpty)
                    ? Column(
                  children: [
                    const SizedBox(height: 10),
                    _isRefreshing
                        ? const _LoadingScreen(showBtn: false)
                        : Column(
                      children: detailMenuList(),
                    )
                  ],
                )
                    : Column(
                  children: const [
                    SizedBox(height: 60),
                    emptyPlaceholderIcon,
                    Text("No menu items to show"),
                  ],
                ),
              ],
            );
          },
        ),
        floatingActionButton: InkWell(
          onTap: () {
            showDialog(
              context: context,
              // anchorPoint: const Offset(100, 0),
              builder: (ctx) => SimpleDialog(
                alignment: Alignment.bottomCenter,
                insetPadding: const EdgeInsets.only(
                  bottom: 60,
                  left: 50,
                  right: 50,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Menu",
                          style: mediumBoldTextStyle.copyWith(
                            color: kBlackTextColor,
                            fontSize: 16,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(ctx).pop(),
                          child: const Icon(
                            Icons.close_rounded,
                            color: kUnselectedIconColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    height: 220,
                    width: double.maxFinite,
                    // color: Colors.amber,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: menuBtnList.length,
                      itemBuilder: (c, i) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(ctx).pop();
                            scrollToIndex = menuBtnList[i]["menu_item"]
                            ["scroll_index"];
                            autoScrollController.scrollToIndex(
                              scrollToIndex,
                              preferPosition: AutoScrollPosition.begin,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  menuBtnList[i]["menu_item"]["title"],
                                  style: const TextStyle(
                                    color: kBlackTextColor,
                                  ),
                                ),
                                Text(menuBtnList[i]["menu_item"]["length"]
                                    .toString()),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          child: Card(
            color: kBlackTextColor,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  menuIcon,
                  SizedBox(width: 6),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {

            return BottomBarWidget(
              title:
              'SAR ${(ref.watch(cartProvider).subTotal).toStringAsFixed(2)}',
              subtitle: (ref.watch(cartProvider).itemsList.length) == 1
                  ? "${(ref.watch(cartProvider).itemsList.length)} item"
                  : '${(ref.watch(cartProvider).itemsList.length)} items',
              btnText: 'View Cart',
              onTap: () {
                saveDataToPrefs;
                print(
                    "items list length: ${ref.watch(cartProvider).cart.items?.length}");

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StoreCart(
                      detail: data,
                      func: callBack,
                    ),
                  ),
                );

                // if (shouldReload) {
                //   setState(() {
                //     isLoading = true;
                //     menuBtnList = [];
                //   });
                //   getAllData();
                // }
              },
            );
          },
        ),),
    );
  }

  List<Widget> detailMenuList() {
    List<Widget> list = [];

    for (int i = 0; i < _response.length; i++) {
      list.add(
        AutoScrollTag(
          key: ValueKey(i),
          controller: autoScrollController,
          index: i,
          child: Column(
            children: [
              ExpandablePanel(
                controller: ExpandableController(initialExpanded: true),
                theme: const ExpandableThemeData(
                  hasIcon: false,
                ),
                header: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _response[i]["category"][0]["title"],
                        style: const TextStyle(
                          color: kBlackTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: kLightTextColor,
                        size: 35,
                      )
                    ],
                  ),
                ),
                collapsed: const SizedBox.shrink(),
                expanded: menuListItems(
                  _response[i]["menu_data"],
                ),
              ),
              const Divider(
                height: 0,
                color: kBoxBorderColor,
              ),
            ],
          ),
        ),
      );
    }

    return list;
  }

  ListView menuListItems(dynamic data) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return RestaurantListItemTile(
          detail: data[index],
        );
      },
    );
  }

  List<Widget> buildVegnonVegList() {
    List<Widget> list = [];
    for (VegOptionList item in vegNonvegList) {
      list.add(
        IgnorePointer(
          ignoring: _isRefreshing,
          child: GestureDetector(
            onTap: () async {
              // setState(() {
                print("button tapped");
                _isRefreshing = true;
              // });
              print(item.sId);
              if (foodCategoryId.isNotEmpty && foodCategoryId == item.sId) {
                foodCategoryId = "";
                await RestaurantRepoService.fetchMenuItems(id: data!.sId!, veg_nonveg_id: foodCategoryId);
              } else {
                foodCategoryId = item.sId!;
                await RestaurantRepoService.fetchMenuItems(id: data!.sId!, veg_nonveg_id: foodCategoryId);}
              // setState(() {
                _isRefreshing = false;
              // });
            },
            child: VegNVegWidget(
              isVeg: item.title == "Veg",
              isTapped: foodCategoryId == item.sId,
            ),
          ),
        ),
      );
    }

    return list;
  }

  List<Widget> buildCuisineeListWidget(List<restaurant_list_model.Cuisinee>? cuisineList) {
    List<Widget> list = [];
    List<restaurant_list_model.Cuisinee>? parseList = [];
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
            // fontSize: 12,
            color: kLightestTextColor,
          ),
        ),
      );
    }
    return list;
  }
}

class RestaurantOfferWidget extends StatelessWidget {
  final String offerTitle, couponCode, uptoAmount;
  const RestaurantOfferWidget({
    Key? key,
    required this.offerTitle,
    required this.couponCode,
    required this.uptoAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 18,
        top: 5,
        right: 5,
        bottom: 5,
      ),
      margin: const EdgeInsets.only(
        left: 18,
        right: 18,
        top: 18,
        bottom: 18,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffECFAFB),
        border: Border.all(
          color: const Color(0xff74D7DD),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          const Image(
            image: AssetImage('assets/images/3.0x/offergreen.png'),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                left: 13,
                top: 9,
                bottom: 9,
              ),
              margin: const EdgeInsets.only(left: 12),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offerTitle,
                    style: mediumBoldTextStyle.copyWith(
                      color: kBlackTextColor,
                      fontSize: 18,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Use $couponCode | Above SAR $uptoAmount', //Use JRoute 20 |
                      style: lightTextStyle.copyWith(
                        fontSize: 12,
                        color: kLightTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  final bool showBtn;
  const _LoadingScreen({
    Key? key,
    required this.showBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: const EdgeInsets.only(left: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showBtn)
              Row(
                children: const [
                  Skelton(
                    height: 35,
                    width: 90,
                  ),
                  SizedBox(width: 15),
                  Skelton(
                    height: 35,
                    width: 90,
                  ),
                ],
              ),
            const SizedBox(height: 10),
            const Skelton(
              height: 30,
              width: 180,
            ),
            const SizedBox(height: 10),
            const Skelton(
              height: 170,
            ),
            const SizedBox(height: 10),
            const Skelton(
              height: 30,
              width: 180,
            ),
            const SizedBox(height: 10),
            const Skelton(
              height: 170,
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantListItemTile extends ConsumerStatefulWidget {
  final dynamic detail;
  const RestaurantListItemTile({
    Key? key,
    required this.detail,
  }) : super(key: key);

  @override
  ConsumerState<RestaurantListItemTile> createState() => _RestaurantListItemTileState();
}

class _RestaurantListItemTileState extends ConsumerState<RestaurantListItemTile> {
  // CartController cartController = Get.find<CartController>();
  bool isAdded = false;

  void resetCounter() {
    setState(() {
      isAdded = false;
    });
  }

  void resetCounterWithAddons() {
    setState(() {
      isWithAddons = false;
    });
  }

  int counterWithAddons = 0;

  void func1(){
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    var storeId = ref.watch(storeIdProvider);
    var discount = ref.watch(discountProvider);
    var itemsList = ref.watch(itemsListProvider);
    var clearAllData = ref.watch(clearAllDataProvider);
    var cart = ref.watch(cartDataProvider);
    var subTotal = ref.watch(subTotalProvider);
    var vendorId = ref.watch(vendorIdProvider);
    var saveDataToPrefs = ref.watch(saveDataToPrefsProvider);
    var addItemToCart = ref.watch(addItemToCartProvider);
    var addItemWithAddonToCart = ref.watch(addItemWithAddonToCartProvider);


    isAdded = false;
    isWithAddons = false;
    for (var item in itemsList) {
      if (widget.detail["addons"] || widget.detail["item_size"]) {
        if (item.itemId == widget.detail["_id"]) {
          counterWithAddons += item.quantity!;
          isWithAddons = true;
        }
      } else if (item.itemId == widget.detail["_id"]) {
        isAdded = item.itemId == widget.detail["_id"];
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 15,
      ),
      margin: const EdgeInsets.only(
        left: 18,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: kBoxBorderColor,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VegIndicatorWidget(
                  isVeg:
                  widget.detail["foodcategories"][0]["title"] == "Veg"),
              const SizedBox(height: 8),
              LimitedBox(
                maxWidth: 180,
                child: Text(
                  widget.detail["itemName"],
                  maxLines: 2,
                  style: mediumBoldTextStyle.copyWith(
                    color: kBlackTextColor,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              ExpandableTextWidget(text: widget.detail["description"]),
              const SizedBox(height: 10),
              Text(
                widget.detail["item_size"]
                    ? "${widget.detail["amountIn"]} ${widget.detail["size_amount"]}"
                    : "${widget.detail["amountIn"]} ${widget.detail["amount"]}",
                style: const TextStyle(
                  color: kAccentColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          SizedBox(
            height: 123,
            width: 110,
            child: Stack(
              children: [
                RoundedImageWidget(
                  image: widget.detail["image"],
                  height: 110,
                  width: 110,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: isAdded
                      ? PlusMinusCounterWidget(
                    detail: widget.detail,
                    func: resetCounter,
                  )
                      : isWithAddons
                      ? CounterWithAddons(
                    func2: func1,
                    counter: counterWithAddons,
                    detail: widget.detail,
                    func: resetCounterWithAddons,
                    addonsList: widget.detail["addons"]
                        ? widget.detail["addons_list"]
                        : null,
                    itemSizeList: widget.detail["item_size"]
                        ? widget.detail["vendor_itemsizes"]
                        : null,
                  )
                      : IgnorePointer(
                    ignoring: isFetchingAddons,
                    child: GestureDetector(
                      onTap: () async {
                        if (storeId.isEmpty ||
                            storeId ==
                                widget.detail["storeId"]) {
                          if (widget.detail["addons"] ||
                              widget.detail["item_size"]) {
                            if (mounted) {
                              await showCustomizeBottomSheet(
                                context,
                                widget.detail["item_size"]
                                    ? widget.detail[
                                "vendor_itemsizes"]
                                    : null,
                                widget.detail["addons"]
                                    ? widget.detail["addons_list"]
                                    : null,
                                widget.detail,
                                storeId,
                                clearAllData,
                                  itemsList,
                                  cart,
                                  vendorId,
                                  addItemWithAddonToCart
                              );
                            }
                          }

                          // if (widget.detail["addons"] ||
                          //     widget.detail["item_size"]) {
                          //   setState(() {
                          //     isFetchingAddons = true;
                          //   });
                          //   if (widget.detail["addons"]) {
                          //     var response =
                          //         await NetworkApi.getResponse(
                          //       url:
                          //           "menu/menu-list?itemId=${widget.detail["_id"]}",
                          //       headers: headersMap,
                          //     );
                          //     if (response["code"] != 200) {
                          //       print("addons");
                          //       showSnackbar(
                          //         context: context,
                          //         title: response["message"],
                          //       );
                          //       setState(() {
                          //         isFetchingAddons = false;
                          //       });
                          //       return;
                          //     }
                          //     setState(() {
                          //       addonsList =
                          //           response["data"]["menuItem"];
                          //     });
                          //     print(addonsList);
                          //   }
                          //   if (widget.detail["item_size"]) {
                          //     var response =
                          //         await NetworkApi.getResponse(
                          //       url:
                          //           "menu/item-size?itemId=${widget.detail["_id"]}",
                          //       headers: headersMap,
                          //     );
                          //     if (response["code"] != 200) {
                          //       print("itemSize");
                          //       showSnackbar(
                          //         context: context,
                          //         title: response["message"],
                          //       );
                          //       setState(() {
                          //         isFetchingAddons = false;
                          //       });
                          //       return;
                          //     }
                          //     setState(() {
                          //       itemSizeList =
                          //           response["data"]["itemSize"];
                          //     });
                          //   }
                          //   if (mounted) {
                          //     await showCustomizeBottomSheet(
                          //       context,
                          //       itemSizeList,
                          //       addonsList,
                          //       widget.detail,
                          //     );
                          //     setState(() {
                          //       isFetchingAddons = false;
                          //     });
                          //   }
                          // }
                          else {
                            cart.storeId =
                            widget.detail["storeId"];
                            storeId =
                            widget.detail["storeId"];

                            vendorId =
                            widget.detail["userId"];
                            cart.vendorId =
                            widget.detail["userId"];

                            addItemToCart(
                              Items(
                                itemId: widget.detail["_id"]
                                    .toString(),
                                itemName:
                                widget.detail["itemName"],
                                itemPrice:
                                widget.detail["amount"],
                                foodCatId: widget
                                    .detail["foodcategories"]
                                [0]["_id"],
                                foodCatTitle: widget.detail[
                                "foodcategories"]
                                [0]["title"] ==
                                    "Veg"
                                    ? "Veg"
                                    : "Non-veg",
                                addons: [],
                                addonIdArray: [],
                                itemSize: "",
                                perItemPrice:
                                widget.detail["amount"],
                                quantity: 1,
                              ),
                            );

                            setState(() {
                              isAdded = true;
                            });
                          }
                        }
                        else {
                          print("cart is not empty");

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) {
                              return SimpleDialog(
                                contentPadding:
                                const EdgeInsets.all(25),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18),
                                ),
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        "Replace cart?",
                                        style: mediumBoldTextStyle
                                            .copyWith(
                                          fontSize: 18,
                                          color: kBlackTextColor,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            Navigator.of(ctx)
                                                .pop(),
                                        child: Container(
                                          padding:
                                          const EdgeInsets
                                              .all(3),
                                          decoration:
                                          BoxDecoration(
                                            shape:
                                            BoxShape.circle,
                                            color:
                                            Colors.grey[200],
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  const Text(
                                    "There are items already present in your cart. Do you want to clear your cart and add new items?",
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: kLightestTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            print("No");
                                            Navigator.of(ctx)
                                                .pop();
                                          },
                                          child:
                                          YellowButtonWidget(
                                            text: "No",
                                            fontSize: 14,
                                            backgroundColor:
                                            kYellowButtonColor
                                                .withOpacity(
                                                0.1),
                                            textColor:
                                            kYellowButtonColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            itemsList
                                                .clear();
                                            storeId = "";
                                            vendorId = "";
                                            clearAllData;

                                            if (widget.detail[
                                                    "addons"] ||
                                                widget.detail[
                                                    "item_size"]) {
                                              if (mounted) {
                                                await showCustomizeBottomSheet(
                                                  context,
                                                  widget.detail[
                                                          "item_size"]
                                                      ? widget.detail[
                                                          "vendor_itemsizes"]
                                                      : null,
                                                  widget.detail[
                                                          "addons"]
                                                      ? widget.detail[
                                                          "addons_list"]
                                                      : null,
                                                  widget.detail,
                                                    storeId,
                                                    clearAllData,
                                                    itemsList,
                                                    cart,
                                                    vendorId,
                                                    addItemWithAddonToCart
                                                );
                                              }
                                            }

                                            else {
                                              cart
                                                      .storeId =
                                                  widget.detail[
                                                      "storeId"];
                                              storeId =
                                                  widget.detail[
                                                      "storeId"];

                                              vendorId =
                                                  widget.detail[
                                                      "userId"];
                                              cart
                                                      .vendorId =
                                                  widget.detail[
                                                      "userId"];

                                              addItemToCart(
                                                Items(
                                                  itemId: widget
                                                      .detail[
                                                          "_id"]
                                                      .toString(),
                                                  itemName: widget
                                                          .detail[
                                                      "itemName"],
                                                  itemPrice: widget
                                                          .detail[
                                                      "amount"],
                                                  addons: [],
                                                  itemSize: "",
                                                  perItemPrice:
                                                      widget.detail[
                                                          "amount"],
                                                  quantity: 1,
                                                ),
                                              );

                                              setState(() {
                                                isAdded = true;
                                              });
                                            }
                                            if (mounted) {
                                              Navigator.of(ctx)
                                                  .pop();
                                            }
                                          },
                                          child:
                                          const YellowButtonWidget(
                                            text: "Replace",
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: AddBtnWidget(
                          isLoading: isFetchingAddons),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  bool isWithAddons = false;
  bool isFetchingAddons = false;
  List? itemSizeList = [];
  List? addonsList = [];

  Future<dynamic> showCustomizeBottomSheet(
      BuildContext context,
      List? itemSizeList,
      List? addonsList,
      dynamic itemDetail,
      String storeId,
      void Function() clearAllData,
      List<Items> itemsList,
      Cart cart,
      String vendorId,
      Function addItemWithAddonToCart

      ) async {
    List<String> addList = [];
    List<Addons> addons = [];
    // List<String> addonsIdArray = [];
    String itemSizeId = (itemSizeList != null && itemSizeList.isNotEmpty)
        ? itemSizeList[0]["_id"]
        : "";
    String itemSizeName = (itemSizeList != null && itemSizeList.isNotEmpty)
        ? itemSizeList[0]["item_size"]
        : "";
    var sizePrice = (itemSizeList != null && itemSizeList.isNotEmpty)
        ? itemSizeList[0]["amount"]
        : itemDetail["amount"];
    var totalPrice = sizePrice;

    List<Widget> addonsWidgetList(StateSetter setState) {
      List<Widget> list = [];

      for (var item in addonsList!) {
        list.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                child: Text(
                  item["addonsTypes"][0]["title"] ?? "",
                  style: mediumBoldTextStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
              ),
              for (int i = 0; i < item["menu_data"].length; i++)
                InkWell(
                  onTap: () {
                    if (!addList.contains(item["menu_data"][i]["_id"])) {
                      print("add on tap");
                      setState(() {
                        addList.add(item["menu_data"][i]["_id"]);

                        addons.add(
                          Addons(
                            addonsId: item["menu_data"][i]["_id"],
                            addonsTypeId: item["menu_data"][i]["addons_typeId"],
                            addonsName: item["menu_data"][i]["title"],
                            quantity: 1,
                            addonsPrice:
                            num.parse(item["menu_data"][i]["amount"]),
                            perAddonsPrice:
                            num.parse(item["menu_data"][i]["amount"]),
                          ),
                        );
                      });

                      totalPrice +=
                          double.parse(item["menu_data"][i]["amount"]);
                    } else {
                      setState(() {
                        addList.remove(item["menu_data"][i]["_id"]);
                      });

                      totalPrice -=
                          double.parse(item["menu_data"][i]["amount"]);

                      addons.removeWhere((element) =>
                      element.addonsId == item["menu_data"][i]["_id"]);
                    }
                    print(addList);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const VegIndicatorWidget(isVeg: true),
                            const SizedBox(width: 9),
                            Text(
                              item["menu_data"][i]["title"],
                              style: TextStyle(
                                  color: addList
                                      .contains(item["menu_data"][i]["_id"])
                                      ? kBlackTextColor
                                      : kLightestTextColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${item["menu_data"][i]["amountIn"]} ${item["menu_data"][i]["amount"]}',
                              style: TextStyle(
                                  color: addList
                                      .contains(item["menu_data"][i]["_id"])
                                      ? kAccentColor
                                      : kLightestTextColor),
                            ),
                            const SizedBox(width: 10),
                            addList.contains(item["menu_data"][i]["_id"])
                                ? const Icon(
                              Icons.radio_button_checked_rounded,
                              color: kAccentColor,
                            )
                                : const Icon(
                              Icons.circle_outlined,
                              color: kLightestTextColor,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              const Divider(),
            ],
          ),
        );
      }

      return list;
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
              ),
              child: Column(
                children: [
                  // TOP HEADER
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: kScaffoldBackgroundColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                itemDetail["itemName"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  print("close");

                                  Navigator.pop(ctx);
                                },
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: kLightTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          if (itemSizeList != null && itemSizeList.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    "Quantity",
                                    style: mediumBoldTextStyle.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                for (var item in itemSizeList)
                                  InkWell(
                                    onTap: () {
                                      itemSizeId = item["_id"];
                                      itemSizeName = item["item_size"];
                                      sizePrice = item["amount"];

                                      if (addons.isNotEmpty) {
                                        totalPrice = sizePrice;
                                        for (var item in addons) {
                                          totalPrice +=
                                              item.perAddonsPrice ?? 0.0;
                                        }
                                        setState(() {});
                                      } else {
                                        setState(() {
                                          totalPrice = sizePrice;
                                        });
                                      }
                                      print(itemSizeId);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const VegIndicatorWidget(
                                                  isVeg: true),
                                              const SizedBox(width: 9),
                                              Text(
                                                item["item_size"],
                                                style: TextStyle(
                                                  color:
                                                  itemSizeId == item["_id"]
                                                      ? kBlackTextColor
                                                      : kLightestTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${item["amountIn"]} ${item["amount"]}',
                                                style: TextStyle(
                                                  color:
                                                  itemSizeId == item["_id"]
                                                      ? kAccentColor
                                                      : kLightestTextColor,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              itemSizeId == item["_id"]
                                                  ? const Icon(
                                                Icons
                                                    .radio_button_checked_rounded,
                                                color: kAccentColor,
                                              )
                                                  : const Icon(
                                                Icons.circle_outlined,
                                                color: kLightestTextColor,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                const Divider(),
                              ],
                            ),
                          if (addonsList != null && addonsList.isNotEmpty)
                            Column(
                              children: addonsWidgetList(setState),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    padding: const EdgeInsets.only(
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    color: Colors.amber,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SAR $totalPrice',
                              style: mediumBoldTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              '1 item',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            if (storeId.isEmpty ||
                                storeId ==
                                    widget.detail["storeId"]) {
                              setState(() {
                                isWithAddons = true;
                                counterWithAddons = 1;
                              });

                              if (kDebugMode) {
                                print("adding item to cart");
                              }

                              cart.storeId =
                                  widget.detail["storeId"];
                              storeId = widget.detail["storeId"];

                              vendorId = widget.detail["userId"];
                              cart.vendorId =
                                  widget.detail["userId"];

                              addItemWithAddonToCart(
                                Items(
                                  itemId: widget.detail["_id"].toString(),
                                  itemName: widget.detail["itemName"],
                                  itemPrice: totalPrice,
                                  addons: addons,
                                  foodCatId: widget.detail["foodcategories"][0]
                                      ["_id"],
                                  foodCatTitle: widget.detail["foodcategories"]
                                              [0]["title"] ==
                                          "Veg"
                                      ? "Veg"
                                      : "Non-veg",
                                  addonIdArray: addList,
                                  itemSize: itemSizeId,
                                  itemSizeName: itemSizeName,
                                  perItemPrice: totalPrice,
                                  quantity: 1,
                                ),
                              );
                              Navigator.pop(ctx);
                            }
                            else {
                              showSnackbar(
                                context: context,
                                title: "Cart is not empty",
                              );
                            }
                          },
                          child: Text(
                            'Add item to cart',
                            style: mediumBoldTextStyle.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class AddBtnWidget extends StatelessWidget {
  final bool? isLoading;
  const AddBtnWidget({
    Key? key,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 90,
      alignment: Alignment.center,
      // padding: const EdgeInsets.symmetric(
      //   horizontal: 24,
      //   vertical: 5,
      // ),
      decoration: BoxDecoration(
        color: const Color(0xffF2FEFF),
        border: Border.all(color: kAccentColor),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: isLoading!
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: kAccentColor,
          strokeWidth: 1,
        ),
      )
          : const Text(
        '+ Add',
        style: TextStyle(
          color: kAccentColor,
          fontSize: 13,
        ),
      ),
    );
  }
}

class OffersListWidget extends StatefulWidget {
  final List offersResponseList;
  const OffersListWidget({
    super.key,
    required this.offersResponseList,
  });

  @override
  State<OffersListWidget> createState() => _OffersListWidgetState();
}

class _OffersListWidgetState extends State<OffersListWidget> {
  int _dotIndex = 0;

  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 105,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.offersResponseList.length,
            itemBuilder: (context, index) {
              FetchOffers offer = widget.offersResponseList[index];
              return RestaurantOfferWidget(
                offerTitle: offer.offerType == "Percentage"
                    ? "${offer.offerAmount?.toStringAsFixed(2)}% Off"
                    : "Flat SAR ${offer.offerAmount?.toStringAsFixed(2)} Off",
                couponCode: offer.couponCode!,
                uptoAmount: offer.minimumAmount!.toStringAsFixed(0),
              );
            },
            onPageChanged: (value) {
              setState(() {
                _dotIndex = value;
              });
            },
          ),
        ),
        if (widget.offersResponseList.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildDotsIndicator(),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> buildDotsIndicator() {
    List<Widget> list = [];

    for (int i = 0; i < widget.offersResponseList.length; i++) {
      list.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          height: 4,
          width: 4,
          decoration: BoxDecoration(
            color: _dotIndex == i ? kAccentColor : Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return list;
  }
}
