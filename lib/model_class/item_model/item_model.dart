import '../addon_model/addons_model.dart';

class Items {
  String? itemId;
  String? itemName;
  num? perItemPrice;
  int? quantity;
  String? foodCatId;
  String? foodCatTitle;
  String? itemSize;
  String? itemSizeName;
  num? itemPrice;
  List<Addons>? addons;
  List<String>? addonIdArray;

  Items({
    this.itemId,
    this.itemName,
    this.perItemPrice,
    this.quantity,
    this.itemSize,
    this.itemSizeName,
    this.itemPrice,
    this.foodCatId,
    this.foodCatTitle,
    this.addons,
    this.addonIdArray,
  });

  Items.fromJson(Map<String, dynamic> json)
      : itemId = json['itemId'] as String? ?? "",
        itemName = json['itemName'] as String? ?? "",
        perItemPrice = json['perItemPrice'] as num?,
        quantity = json['quantity'] as int?,
        itemSize = json['item_size'] as String? ?? "",
        itemSizeName = json['item_size_name'] as String? ?? "",
        itemPrice = json['itemPrice'] as num?,
        foodCatId = json['foodCatId'] as String? ?? "",
        foodCatTitle = json['foodCatTitle'] as String? ?? "",
        addonIdArray = (json['addonIdArray'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        addons = (json['addons'] as List?)
            ?.map((dynamic e) => Addons.fromJson(e as Map<String, dynamic>))
            .toList();

  // Items.fromJson(Map<String, dynamic> json) {
  //   itemId = json['itemId'] ?? "";
  //   itemName = json['itemName'] ?? "";
  //   perItemPrice = json['perItemPrice'];
  //   quantity = json['quantity'] ?? "";
  //   itemSize = json['item_size'] ?? "";
  //   itemSizeName = json['item_size_name'] ?? "";
  //   itemPrice = json['itemPrice'] ?? "";
  //   foodCatId = json["foodCatId"] ?? "";
  //   foodCatTitle = json["foodCatTitle"] ?? "";

  //   addonIdArray = json['addonIdArray'].cast<String>() ?? [];

  //   if (json['addons'] != null) {
  //     addons = <Addons>[];
  //     json['addons'].forEach((v) {
  //       addons?.add(Addons.fromJson(v));
  //     });
  //   }
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemId'] = itemId;
    data['itemName'] = itemName;
    data['item_size_name'] = itemSizeName;
    data['perItemPrice'] = perItemPrice ?? 0;
    data['quantity'] = quantity ?? 0;
    data["foodCatId"] = foodCatId;
    data["foodCatTitle"] = foodCatTitle;

    if (itemSize != null && itemSize!.isNotEmpty) {
      data['item_size'] = itemSize;
    }

    data['itemPrice'] = itemPrice ?? 0;

    data['addonIdArray'] = addonIdArray;

    if (addons != null) {
      data['addons'] = addons?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
