import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/cart_controller.dart';
import '../model_class/addon_id_model/addonsId_model.dart';
import '../model_class/addon_model/addons_model.dart';
import '../model_class/item_model/item_model.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import 'package:collection/collection.dart';

import '../view/restaurant_screen/widgets/veg_indicator_widget.dart';


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



class PlusMinusCounterWidget extends ConsumerStatefulWidget {
  final EdgeInsets? margin;
  final dynamic detail;
  Function? func;
  PlusMinusCounterWidget({
    Key? key,
    this.margin = const EdgeInsets.symmetric(horizontal: 12),
    this.detail,
    this.func,
  }) : super(key: key);

  @override
  ConsumerState<PlusMinusCounterWidget> createState() => _PlusMinusCounterWidgetState();
}

class _PlusMinusCounterWidgetState extends ConsumerState<PlusMinusCounterWidget> {
  // int counter = 1;
  // CartController cartController = CartController();

  @override
  void initState() {
    // if (cartController.cart.items != null &&
    //     cartController.cart.items!.isNotEmpty) {
    //   var index = cartController.cart.items?.indexWhere((element) {
    //     return element.itemId == widget.detail["_id"];
    //   });
    //   if (index != null) {
    //     counter = cartController.itemsList[index].quantity ?? 1;
    //   }
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int counter = 1;
    if (ref.watch(cartProvider).cart.items != null &&
        ref.watch(cartProvider).cart.items!.isNotEmpty) {
      var index = ref.watch(cartProvider).cart.items?.indexWhere((element) {
        return element.itemId == widget.detail["_id"];
      });
      if (index != null && index != -1) {
        counter = ref.watch(cartProvider).itemsList[index.toInt()].quantity ?? 1;
      }
    }
    return Container(
      margin: widget.margin,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 3,
      ),
      decoration: const BoxDecoration(
        color: kAccentColor,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (counter > 1) {
                setState(() {
                  counter = counter - 1;
                });

                print("counter: $counter");

                ref.watch(cartProvider).reduceQuantityOfItem(
                  ref: ref,
                  Items(
                    itemId: widget.detail["_id"].toString(),
                    itemName: widget.detail["itemName"],
                    itemPrice:
                    (counter - 1).toDouble() * widget.detail["amount"],
                    addons: [],
                    itemSize: "",
                    foodCatId: widget.detail["foodcategories"][0]["_id"],
                    foodCatTitle:
                    widget.detail["foodcategories"][0]["title"] == "Veg"
                        ? "Veg"
                        : "Non-veg",
                    perItemPrice: widget.detail["amount"],
                    quantity: counter - 1,
                  ),
                );
              } else {
                // controller.deleteItem(widget.detail["_id"]);
                widget.func!();
              }
            },
            child: const Icon(
              Icons.remove,
              color: Colors.white,
              size: 20,
            ),
          ),
          Text(
            '$counter',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          InkWell(
            onTap: () {
              print('plus');

              // setState(() {
              //   counter = counter + 1;
              // });

              print("counter: $counter");

              ref.watch(cartProvider).increaseQuantityOfItem(
                Items(
                  itemId: widget.detail["_id"].toString(),
                  itemName: widget.detail["itemName"],
                  itemPrice:
                  (counter + 1).toDouble() * widget.detail["amount"],
                  addons: [],
                  itemSize: "",
                  foodCatId: widget.detail["foodcategories"][0]["_id"],
                  foodCatTitle:
                  widget.detail["foodcategories"][0]["title"] == "Veg"
                      ? "Veg"
                      : "Non-veg",
                  perItemPrice: widget.detail["amount"],
                  quantity: counter + 1,
                ),
                ref: ref
              );
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
}

class CounterWithAddons extends ConsumerWidget {
  final EdgeInsets? margin;
  final dynamic detail;
  Function? func;
  List? addonsList, itemSizeList;
  int? counter;
  Function? func2;

  CounterWithAddons({
    super.key,
    this.margin = const EdgeInsets.symmetric(horizontal: 12),
    this.detail,
    this.func,
    this.addonsList,
    this.itemSizeList,
    this.counter,
    this.func2
  });

  int counters = 0;
  List? itemSizeLists = [];
  List? addonsLists = [];

  @override
  Widget build(BuildContext context,ref) {
    int value = 0;
    for (var item in ref.watch(cartProvider).itemsList) {
      if (item.itemId == detail["_id"]) {
        value += item.quantity ?? 0;
      }
    }
    if (value == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        func!();
      });
    }

    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 3,
      ),
      decoration: const BoxDecoration(
        color: kAccentColor,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              _showItemsBottomSheet(
                context,
                add,
                ref,
                func2!
              );
            },
            child: const Icon(
              Icons.remove,
              color: Colors.white,
              size: 20,
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          InkWell(
            onTap: () {
              // print("*****");
              // print(cartController.itemsList[0].quantity);
              // print(cartController.itemsList[0].itemPrice);
              // print(cartController.itemsList[0].perItemPrice);

              // print(cartController.itemsList[1].quantity);
              // print(cartController.itemsList[1].itemPrice);
              // print(cartController.itemsList[1].perItemPrice);
              // print("*****");

              _showItemsBottomSheet(
                context,
                add,
                ref,
                func2!
              );
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

  void add() {}

  void dropBottomSheet(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<dynamic> _showItemsBottomSheet(BuildContext context, Function add, WidgetRef ref, Function func2) {
    List<Widget> getItems(List<Items> items, BuildContext context) {
      List<Widget> list = [];
      for (var element in items) {
        if (element.itemId == detail["_id"]) {
          list.add(
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(element.itemName ?? ""),
                      if (element.itemSize?.isNotEmpty ?? false)
                        Text(
                          element.itemSizeName ?? "",
                          style: const TextStyle(
                            fontSize: 12,
                            color: kLightestTextColor,
                          ),
                        ),
                      if (element.addons?.isNotEmpty ?? false)
                        SizedBox(
                          width: 250,
                          child: Wrap(
                            children: [
                              for (int i = 0; i < element.addons!.length; i++)
                                Text(
                                  i != element.addons!.length - 1
                                      ? "${element.addons![i].addonsName}, "
                                      : "${element.addons![i].addonsName}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kLightestTextColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  BottomSheetCounter(
                    item: element,
                    func: dropBottomSheet,
                    ref: ref,
                    func2: func2
                  ),
                ],
              ),
            ),
          );
        }
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
          builder: (c, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.4,
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
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                detail["itemName"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  print("close");
                                  // getItems();

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
                      child: SingleChildScrollView(
                        child: Column(
                          children: getItems(
                            ref.watch(cartProvider).itemsList,
                            // controller.itemsList,
                            ctx,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: kBoxBorderColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await _showCustomizeBottomSheet(
                            ctx,
                            itemSizeList,
                            addonsList,
                            detail,
                          );

                          // if (shouldPop && mounted) {
                          //   Navigator.pop(ctx);
                          // }
                        },
                        child: const Text("+ Add New Customization"),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _showCustomizeBottomSheet(
      BuildContext context,
      List? itemSizeList,
      List? addonsList,
      dynamic itemDetail,
      ) async {
    List<String> addList = [];
    List<Addons> addons = [];
    List<AddonId> addonsIdArray = [];
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

                        addonsIdArray.add(
                          AddonId(addonsId: item["menu_data"][i]["_id"]),
                        );

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

                      print(addList.length);
                    } else {
                      setState(() {
                        addList.remove(item["menu_data"][i]["_id"]);
                      });

                      totalPrice -=
                          double.parse(item["menu_data"][i]["amount"]);

                      addonsIdArray.removeWhere((element) =>
                      element.addonsId == item["menu_data"][i]["_id"]);

                      addons.removeWhere((element) =>
                      element.addonsId == item["menu_data"][i]["_id"]);
                    }
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
                            ),
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

    return await showModalBottomSheet<bool>(
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
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                          if (itemSizeList != null &&
                              itemSizeList.isNotEmpty)
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
                                                  color: itemSizeId ==
                                                      item["_id"]
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
                                                  color: itemSizeId ==
                                                      item["_id"]
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
                                                color:
                                                kLightestTextColor,
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
                            if (CartController().storeId.isEmpty ||
                                CartController().storeId ==
                                    detail["storeId"]) {
                              // setState(() {
                              //   isWithAddons = true;
                              //   counterWithAddons = 1;
                              // });

                              print("adding item to cart");

                              CartController().cart!.storeId =
                              detail["storeId"];
                              CartController().storeId =
                              detail["storeId"];

                              CartController().vendorId =
                              detail["userId"];
                              CartController().cart!.vendorId =
                              detail["userId"];

                              print(itemSizeId);

                              CartController().addItemWithAddonToCart(
                                Items(
                                  itemId: detail["_id"].toString(),
                                  itemName: detail["itemName"],
                                  itemPrice: totalPrice,
                                  addons: addons,
                                  foodCatId: detail["foodcategories"]
                                  [0]["_id"],
                                  foodCatTitle:
                                  detail["foodcategories"][0]
                                  ["title"] ==
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
                              Navigator.pop(ctx, true);
                              Navigator.pop(ctx);
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
    ) ??
        false;
  }
}

class BottomSheetCounter extends StatefulWidget {
  final Items item;
  final void Function(BuildContext context)? func;
  final WidgetRef ref;

  const BottomSheetCounter({
    Key? key,
    required this.item,
    this.func,
    required this.ref, required Function func2
  }) : super(key: key);

  @override
  State<BottomSheetCounter> createState() => _BottomSheetCounterState();
}

class _BottomSheetCounterState extends State<BottomSheetCounter> {
  // int counter = 0;
  // final CartController cartController = Get.find<CartController>();

  void initializeCounter() {
    print("bottom sheet counter");
  }

  @override
  Widget build(BuildContext context) {
    int counter = 0;

     widget.ref.watch(cartProvider).itemsList.indexWhere((element) {
      if (element.itemId == widget.item.itemId &&
          element.itemSize == widget.item.itemSize &&
          ((widget.item.addonIdArray != null &&
              (widget.item.addonIdArray?.isNotEmpty ?? false)) &&
              (element.addonIdArray != null &&
                  (element.addonIdArray?.isNotEmpty ?? false)))) {
        if (element.addonIdArray!.length ==
            widget.item.addonIdArray!.length) {
          Function unOrdDeepEq =
              const DeepCollectionEquality.unordered().equals;

          if (unOrdDeepEq(element.addonIdArray, widget.item.addonIdArray)) {
            counter = widget.item.quantity ?? 1;
          }

          return unOrdDeepEq(
              element.addonIdArray, widget.item.addonIdArray);
        } else {
          counter = widget.item.quantity ?? 1;
          return true;
        }
      } else if (element.itemId == widget.item.itemId &&
          element.itemSize == widget.item.itemSize) {
        if ((element.addonIdArray == null ||
            element.addonIdArray!.isEmpty) &&
            (widget.item.addonIdArray == null ||
                widget.item.addonIdArray!.isEmpty)) {
          counter = widget.item.quantity ?? 1;
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    });

    print("${widget.item.itemSizeName} $counter");

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: kScaffoldBackgroundColor,
        border: Border.all(color: kAccentColor),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (counter > 1) {
                var newItem = Items(
                    itemId: widget.item.itemId,
                    itemName: widget.item.itemName,
                    perItemPrice: widget.item.perItemPrice,
                    itemSize: widget.item.itemSize,
                    itemSizeName: widget.item.itemSizeName,
                    addons: widget.item.addons,
                    addonIdArray: widget.item.addonIdArray,
                    foodCatId: widget.item.foodCatId,
                    foodCatTitle: widget.item.foodCatTitle,
                    quantity: counter - 1,
                    itemPrice:
                    widget.item.itemPrice! - widget.item.perItemPrice!);

                widget.ref.watch(cartProvider).decreaseQuantityWithAddons(newItem);
                setState(() {});
                widget.func;
              }
              else {
                widget.ref.watch(cartProvider).deleteItemWithAddons(widget.item);
                widget.func!(context);
                setState(() {});
                widget.func;
              }
            },
            child: const Icon(
              Icons.remove,
              size: 18,
            ),
          ),
          const SizedBox(width: 15),
          Text("$counter"),
          const SizedBox(width: 15),
          InkWell(
            onTap: () {
              var newItem = Items(
                  itemId: widget.item.itemId,
                  itemName: widget.item.itemName,
                  perItemPrice: widget.item.perItemPrice,
                  itemSize: widget.item.itemSize,
                  itemSizeName: widget.item.itemSizeName,
                  addons: widget.item.addons,
                  addonIdArray: widget.item.addonIdArray,
                  foodCatId: widget.item.foodCatId,
                  foodCatTitle: widget.item.foodCatTitle,
                  quantity: counter + 1,
                  itemPrice:
                  widget.item.itemPrice! + widget.item.perItemPrice!);

              widget.ref.watch(cartProvider).increaseQuantityWithAddons(newItem);
              setState(() {});
              widget.func;
            },
            child: const Icon(
              Icons.add,
              size: 18,
            ),
          )
        ],
      ),
    );
  }
}
