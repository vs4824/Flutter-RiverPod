import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import '../model_class/address_model.dart';
import '../model_class/cart_model.dart';
import '../model_class/item_model/item_model.dart';
import '../utils/shared_pref_keys.dart';
import '../utils/util.dart';


final cartProvider = ChangeNotifierProvider((_) => CartController());


class CartController with ChangeNotifier{
  Cart cart = Cart();
  String storeId = "",
      vendorId = "",
      orderId = "",
      couponCode = "",
      offerType = "";
  bool isCartAdded = false;

  bool isCouponApplied = false;

  List<Items> itemsList = <Items>[];

  int totalQuantity = 0;
  String offerText = "";
  num subTotal = 0.0,
      discount = 0.0,
      offerAmount = 0.0,
      uptoAmount = 0.0,
      minimumOrderAmount = 0.0;
  num amountToPay = 0, taxPerc = 0, taxAmount = 0;
  var addressModel = Address();

  void loadDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var data = prefs.getString(saveToCartKey);

    if (data != null && data.isNotEmpty) {
      isCartAdded = prefs.getBool(isCartAddedKey) ?? false;
      orderId = prefs.getString(orderIdKey) ?? "";
      cart = Cart.decode(data);
      vendorId = cart.vendorId ?? "";
      storeId = cart.storeId ?? "";
      itemsList = cart.items ?? [];
      notifyListeners();
      // update();
    } else {
      cart = Cart();
      itemsList = cart.items ?? [];
      cart.vendorId = "";
      cart.storeId = "";

      cart.items = [];
      cart.totalItems = 0;
      notifyListeners();
      // update();
    }

    updateTqTp();

    // update();
    notifyListeners();
    if (kDebugMode) {
      print(cart.storeId);
      print("cart items length");
      print(cart.items?.length ?? 0);
    }
  }

  void addItemToCart(Items item) {
    itemsList.add(item);
    updateTqTp();
  }

  void increaseQuantityOfItem(Items item, {required WidgetRef ref}) {
    int? index = ref.watch(cartProvider).itemsList.indexWhere(
      (element) => element.itemId == item.itemId,
    );

    ref.watch(cartProvider).itemsList[index.toInt()] = item;
    updateTqTp();
  }

  void reduceQuantityOfItem(Items item, {required WidgetRef ref}) {
    int? index = ref.watch(cartProvider).itemsList.indexWhere(
      (element) => element.itemId == item.itemId,
    );

    ref.watch(cartProvider).itemsList[index.toInt()] = item;
    updateTqTp();
  }

  void addItemWithAddonToCart(Items item) {
    var index = itemsList.indexWhere((element) {
      if (element.itemId == item.itemId &&
          element.itemSize == item.itemSize &&
          ((item.addonIdArray != null &&
                  (item.addonIdArray?.isNotEmpty ?? false)) &&
              (element.addonIdArray != null &&
                  (element.addonIdArray?.isNotEmpty ?? false)))) {
        if (element.addonIdArray!.length == item.addonIdArray!.length) {
          print(
              "element has size and addonIdArray ${const DeepCollectionEquality.unordered().equals(element.addonIdArray, item.addonIdArray)}");
          Function unOrdDeepEq =
              const DeepCollectionEquality.unordered().equals;

          return unOrdDeepEq(element.addonIdArray, item.addonIdArray);
        }
        else {
          print("size matches and addons don't");
          return false;
        }
      }
      else if (element.itemId == item.itemId &&
          element.itemSize == item.itemSize) {
        if ((element.addonIdArray == null || element.addonIdArray!.isEmpty) &&
            (item.addonIdArray == null || item.addonIdArray!.isEmpty)) {
          print("has size only");
          return true;
        }
        else {
          print("has size only false");
          return false;
        }
      }
      else {
        print("has no size or addons");
        return false;
      }
    });

    if (index != -1) {
      print("index: $index");

      item.quantity = itemsList[index.toInt()].quantity! + 1;
      // (int.parse(itemsList[index].quantity ?? "1") + 1).toString();

      // itemsList[index] = Items.fromJson(item.toJson());

      itemsList[index.toInt()].itemId = item.itemId;
      itemsList[index.toInt()].itemName = item.itemName;
      itemsList[index.toInt()].addons = item.addons;
      itemsList[index.toInt()].itemSize = item.itemSize;
      itemsList[index.toInt()].itemSizeName = item.itemSizeName;
      itemsList[index.toInt()].itemPrice =
          itemsList[index.toInt()].itemPrice! + item.perItemPrice!;
      // (double.parse(itemsList[index].itemPrice ?? "0") +
      //         double.parse(item.perItemPrice ?? "0"))
      //     .toString();
      itemsList[index.toInt()].quantity = item.quantity;
      itemsList[index.toInt()].perItemPrice = item.perItemPrice;

      print(itemsList[index.toInt()].quantity);
      print(itemsList[index.toInt()].itemPrice);
      print(itemsList[index.toInt()].perItemPrice);
    }
    else {
      print("index -1");
      itemsList.add(item);
      print(itemsList.length);
    }
    // update();
    notifyListeners();
    updateTqTp();
  }

  void increaseQuantityWithAddons(Items item) {
    print("increaseQuantityWithAddons");

    var index = itemsList.indexWhere((element) {
      if (element.itemId == item.itemId &&
          element.itemSize == item.itemSize &&
          ((item.addonIdArray != null &&
                  (item.addonIdArray?.isNotEmpty ?? false)) &&
              (element.addonIdArray != null &&
                  (element.addonIdArray?.isNotEmpty ?? false)))) {
        if (element.addonIdArray!.length == item.addonIdArray!.length) {
          print(
              "element has size and addonIdArray ${const DeepCollectionEquality.unordered().equals(element.addonIdArray, item.addonIdArray)}");
          Function unOrdDeepEq =
              const DeepCollectionEquality.unordered().equals;

          return unOrdDeepEq(element.addonIdArray, item.addonIdArray);
        } else {
          print("size matches and addons don't");
          return false;
        }
      } else if (element.itemId == item.itemId &&
          element.itemSize == item.itemSize) {
        if ((element.addonIdArray == null || element.addonIdArray!.isEmpty) &&
            (item.addonIdArray == null || item.addonIdArray!.isEmpty)) {
          print("has size only");
          return true;
        } else {
          print("has size only false");
          return false;
        }
      } else {
        print("has no size or addons");
        return false;
      }
    });

    if (index != -1) {
      itemsList[index.toInt()].itemId = item.itemId;
      itemsList[index.toInt()].itemName = item.itemName;
      itemsList[index.toInt()].itemSize = item.itemSize;
      itemsList[index.toInt()].itemSizeName = item.itemSizeName;
      itemsList[index.toInt()].perItemPrice = item.perItemPrice;
    itemsList[index.toInt()].addons = item.addons;

      itemsList[index.toInt()].itemPrice =
          itemsList[index.toInt()].itemPrice! + item.perItemPrice!;

      itemsList[index.toInt()].quantity = item.quantity;
    }

    // update();
    notifyListeners();
    updateTqTp();
    saveDataToPrefs();
  }

  void decreaseQuantityWithAddons(Items item) {
    // for (var element in itemsList) {
    //   if (element.itemId == item.itemId) {
    //     if (item.itemSize != null &&
    //         item.itemSize!.isNotEmpty &&
    //         element.itemSize == item.itemSize) {
    //       if (item.addons != null && item.addons!.isNotEmpty) {
    //         if (listEquals(item.addons, element.addons)) {
    //           element.itemId = item.itemId;
    //           element.itemName = item.itemName;
    //           element.itemSize = item.itemSize;
    //           element.itemSizeName = item.itemSizeName;
    //           element.perItemPrice = item.perItemPrice;
    //           element.addons = item.addons;
    //           element.itemPrice = item.itemPrice;
    //           element.quantity = item.quantity;
    //           break;
    //         }
    //       } else {
    //         element.itemId = item.itemId;
    //         element.itemName = item.itemName;
    //         element.itemSize = item.itemSize;
    //         element.itemSizeName = item.itemSizeName;
    //         element.perItemPrice = item.perItemPrice;
    //         element.addons = item.addons;
    //         element.itemPrice = item.itemPrice;
    //         element.quantity = item.quantity;
    //         break;
    //       }
    //     } else {
    //       if (item.addons != null && item.addons!.isNotEmpty) {
    //         if (listEquals(item.addons, element.addons)) {
    //           element.itemId = item.itemId;
    //           element.itemName = item.itemName;
    //           element.itemSize = item.itemSize;
    //           element.itemSizeName = item.itemSizeName;
    //           element.perItemPrice = item.perItemPrice;
    //           element.addons = item.addons;
    //           element.itemPrice = item.itemPrice;
    //           element.quantity = item.quantity;
    //           break;
    //         }
    //       } else {
    //         element.itemId = item.itemId;
    //         element.itemName = item.itemName;
    //         element.itemSize = item.itemSize;
    //         element.itemSizeName = item.itemSizeName;
    //         element.perItemPrice = item.perItemPrice;
    //         element.addons = item.addons;
    //         element.itemPrice = item.itemPrice;
    //         element.quantity = item.quantity;
    //         print("quantity with addons${element.quantity}");
    //         break;
    //       }
    //     }
    //   }
    // }

    print("decreaseQuantityWithAddons");

    var index = itemsList.indexWhere((element) {
      if (element.itemId == item.itemId &&
          element.itemSize == item.itemSize &&
          ((item.addonIdArray != null &&
                  (item.addonIdArray?.isNotEmpty ?? false)) &&
              (element.addonIdArray != null &&
                  (element.addonIdArray?.isNotEmpty ?? false)))) {
        if (element.addonIdArray!.length == item.addonIdArray!.length) {
          print(
              "element has size and addonIdArray ${const DeepCollectionEquality.unordered().equals(element.addonIdArray, item.addonIdArray)}");
          Function unOrdDeepEq =
              const DeepCollectionEquality.unordered().equals;

          return unOrdDeepEq(element.addonIdArray, item.addonIdArray);
        } else {
          print("size matches and addons don't");
          return false;
        }
      } else if (element.itemId == item.itemId &&
          element.itemSize == item.itemSize) {
        if ((element.addonIdArray == null || element.addonIdArray!.isEmpty) &&
            (item.addonIdArray == null || item.addonIdArray!.isEmpty)) {
          print("has size only");
          return true;
        } else {
          print("has size only false");
          return false;
        }
      } else {
        print("has no size or addons");
        return false;
      }
    });

    if (index != -1) {
      itemsList[index!.toInt()].itemId = item.itemId;
      itemsList[index.toInt()].itemName = item.itemName;
      itemsList[index.toInt()].itemSize = item.itemSize;
      itemsList[index.toInt()].itemSizeName = item.itemSizeName;
      itemsList[index.toInt()].perItemPrice = item.perItemPrice;
      itemsList[index.toInt()].addons = item.addons;

      itemsList[index.toInt()].itemPrice =
          itemsList[index.toInt()].itemPrice! - item.perItemPrice!;

      itemsList[index.toInt()].quantity = item.quantity;
    }

    // update();
    notifyListeners();
    updateTqTp();
    saveDataToPrefs();
  }

  void deleteItemWithAddons(Items item) {
    print("deleteItemWithAddons");
    var index = itemsList.indexWhere((element) {
      if (element.itemId == item.itemId &&
          element.itemSize == item.itemSize &&
          ((item.addonIdArray != null &&
                  (item.addonIdArray?.isNotEmpty ?? false)) &&
              (element.addonIdArray != null &&
                  (element.addonIdArray?.isNotEmpty ?? false)))) {
        if (element.addonIdArray!.length == item.addonIdArray!.length) {
          print(
              "element has size and addonIdArray ${const DeepCollectionEquality.unordered().equals(element.addonIdArray, item.addonIdArray)}");
          Function unOrdDeepEq =
              const DeepCollectionEquality.unordered().equals;

          return unOrdDeepEq(element.addonIdArray, item.addonIdArray);
        } else {
          print("size matches and addons don't");
          return false;
        }
      } else if (element.itemId == item.itemId &&
          element.itemSize == item.itemSize) {
        if ((element.addonIdArray == null || element.addonIdArray!.isEmpty) &&
            (item.addonIdArray == null || item.addonIdArray!.isEmpty)) {
          print("has size only");
          return true;
        } else {
          print("has size only false");
          return false;
        }
      } else {
        print("has no size or addons");
        return false;
      }
    });

    if (index != -1) {
      itemsList.removeAt(index);
    }

    // update();
    notifyListeners();
    updateTqTp();
    saveDataToPrefs();
  }

  void deleteItem(String itemId) {
    itemsList.removeWhere((element) => element.itemId == itemId);
    // update();
    notifyListeners();
    updateTqTp();
  }

  void updateItemAtIndex(Items item, int index, int counter) {
    item.itemPrice = item.perItemPrice! * counter.toDouble();

    itemsList[index.toInt()].itemId = item.itemId;
    itemsList[index.toInt()].itemName = item.itemName;
    itemsList[index.toInt()].itemPrice = item.itemPrice;
    itemsList[index.toInt()].itemSize = item.itemSize;
    itemsList[index.toInt()].itemSizeName = item.itemSizeName;
    itemsList[index.toInt()].perItemPrice = item.perItemPrice;
    itemsList[index.toInt()].quantity = counter;
    itemsList[index.toInt()].addons = item.addons;

    updateTqTp();
    saveDataToPrefs();
  }

  void deleteItemAtIndex(int index) {
    itemsList.removeAt(index);

    updateTqTp();
    saveDataToPrefs();
  }

  void updateTqTp() {
    totalQuantity = 0;
    subTotal = 0;
    for (var item in itemsList) {
      totalQuantity += item.quantity!;

      subTotal += item.itemPrice!;

      // update();
      notifyListeners();
    }
    if (totalQuantity == 0) {
      clearAllData();
    }
    // update();
    notifyListeners();
  }

  void setOfferText(String text) {
    offerText = text;
    // update();
    notifyListeners();
  }

  void clearOfferText() {
    offerText = "";
    // update();
    notifyListeners();
  }

  void setOffer({
    required bool isCouponApplied,
    required String couponCode,
    required String offerType,
    required num offerAmount,
    required num uptoAmount,
    required num minimumOrderAmount,
  }) {
    this.isCouponApplied = isCouponApplied;
    this.couponCode = couponCode;
    this.offerType = offerType;
    this.offerAmount = offerAmount;
    this.uptoAmount = uptoAmount;
    this.minimumOrderAmount = minimumOrderAmount;
  }

  void clearOffer() {
    isCouponApplied = false;
    uptoAmount = minimumOrderAmount = offerAmount = discount = 0;
    offerText = offerType = couponCode = "";
    // update();
    notifyListeners();
  }

  void calculateAmount() {
    if (subTotal >= minimumOrderAmount) {
      if (offerType == "Percentage") {
        discount = subTotal * (offerAmount / 100);
        if (discount > uptoAmount) discount = uptoAmount;
      }
      if (offerType == "Flat") {
        discount = offerAmount;
      }
    } else {
      clearOffer();
    }
    amountToPay = 0;
    taxAmount = (subTotal * (taxPerc / 100));
    amountToPay = (taxAmount + subTotal) - discount;
    // update();
    notifyListeners();
  }

  Map<String, dynamic> compileAllCart({
    required String status,
    String? pickupTime = "",
    String? pickupDate = "",
    String? pickupDateTime = "",
  }) {
    DateTime date = DateTime.now();
    if (orderId.isNotEmpty) {
      cart.orderId = orderId;
    }

    cart.totalItems = CartController().itemsList.length;
    cart.status = status;
    cart.items = CartController().itemsList;
    cart.storeId = CartController().storeId;
    cart.vendorId = CartController().vendorId;
    cart.subTotal = CartController().subTotal;
    cart.description = "just adding to cart";
    cart.taxesCharges = CartController().taxPerc.toString();
    cart.taxChargesAmount = CartController().taxAmount.toString();
    cart.totalAmount = CartController().amountToPay;
    cart.orderDate = dateFormatter(date);
    cart.orderTime = timeFormatter(date);
    cart.orderDateTime = dateTimeFormatter(date);
    cart.pickupDate = pickupDate;
    cart.pickupTime = pickupTime;
    cart.pickupDateTime = pickupDateTime;

    cart.address = CartController().addressModel;

    log(cart.toJson().toString());

    return cart.toJson();
  }

  void clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(saveToCartKey);
    await prefs.setBool(isCartAddedKey, false);
    await prefs.setString(orderIdKey, "");
  }

  void clearAllData() {
    storeId = "";
    vendorId = "";
    orderId = "";
    couponCode = "";
    isCartAdded = false;
    taxAmount = 0;
    totalQuantity = 0;
    taxPerc = 0;
    amountToPay = 0;
    discount = 0;
    subTotal = 0;
    itemsList = [];
    taxPerc = 0;
    isCouponApplied = false;
    uptoAmount = minimumOrderAmount = offerAmount = discount = 0;
    offerText = offerType = couponCode = "";
    // cart = Cart();
    clearPrefs();

    saveDataToPrefs();
    // update(); //TODO TEST UI UPDATE
    notifyListeners();
  }

  void saveDataToPrefs() async {
    compileAllCart(status: "");
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(saveToCartKey);
    await prefs.setString(saveToCartKey, Cart.encode(cart!));
    // update();
    notifyListeners();
  }
}
