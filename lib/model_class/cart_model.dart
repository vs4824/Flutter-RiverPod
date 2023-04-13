import 'dart:convert';
import 'package:riverpod_examples/model_class/status_list_model.dart';

import 'address_model.dart';
import 'item_model/item_model.dart';

class Cart {
  String? orderId;
  String? vendorId;
  String? storeId;
  List<Items>? items;
  int? totalItems;
  String? status;
  List<StatusList>? statusList;
  String? description;
  String? orderDateTime;
  String? orderTime;
  String? orderDate;
  String? pickupDate;
  String? pickupTime;
  String? pickupDateTime;
  String? couponCode;
  num? couponCodeAmount;
  num? subTotal;
  String? taxesCharges;
  String? taxChargesAmount;
  num? totalAmount;
  Address? address;

  Cart({
    this.orderId,
    this.vendorId,
    this.storeId,
    this.items,
    this.totalItems,
    this.status,
    this.statusList,
    this.description,
    this.orderDateTime,
    this.orderTime,
    this.orderDate,
    this.pickupDate,
    this.pickupTime,
    this.pickupDateTime,
    this.couponCode,
    this.couponCodeAmount,
    this.subTotal,
    this.taxesCharges,
    this.taxChargesAmount,
    this.totalAmount,
    this.address,
  });

  Cart.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("order_id")) {
      orderId = json["order_id"];
    }
    vendorId = json['vendorId'];
    storeId = json['storeId'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
    totalItems = json['totalItems'];
    status = json['status'];
    if (json['statusList'] != null) {
      statusList = <StatusList>[];
      json['statusList'].forEach((v) {
        statusList?.add(StatusList.fromJson(v));
      });
    }
    description = json['description'];
    orderDateTime = json['order_dateTime'];
    orderTime = json['order_time'];
    orderDate = json['order_date'];
    pickupDate = json["pickup_date"];
    pickupTime = json["pickup_time"];
    pickupDateTime = json["pickup_dateTime"];
    couponCode = json['couponCode'];
    couponCodeAmount = json['couponCodeAmount'];
    subTotal = json['subTotal'];
    taxesCharges = json['taxes_Charges'];
    taxChargesAmount = json["taxes_Charges_amount"];
    totalAmount = json['totalAmount'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendorId'] = vendorId;
    data['storeId'] = storeId;
    if (orderId != null && orderId!.isNotEmpty) {
      data["order_id"] = orderId;
    }
    if (items != null) {
      data['items'] = items?.map((v) => v.toJson()).toList();
    }
    data['totalItems'] = totalItems;
    data['status'] = status ?? "";
    if (statusList != null) {
      data['statusList'] = statusList?.map((v) => v.toJson()).toList();
    }
    if (description != null && description!.isNotEmpty) {
      data['description'] = description ?? "";
    }

    if (orderDateTime != null && orderDateTime!.isNotEmpty) {
      data['order_dateTime'] = orderDateTime ?? "";
    }
    if (orderTime != null && orderTime!.isNotEmpty) {
      data['order_time'] = orderTime ?? "";
    }
    if (orderDate != null && orderDate!.isNotEmpty) {
      data['order_date'] = orderDate ?? "";
    }
    if (pickupDate != null && pickupDate!.isNotEmpty) {
      data['pickup_date'] = pickupDate ?? "";
    }
    if (pickupTime != null && pickupTime!.isNotEmpty) {
      data['pickup_time'] = pickupTime ?? "";
    }
    if (pickupDateTime != null && pickupDateTime!.isNotEmpty) {
      data['pickup_dateTime'] = pickupDateTime ?? "";
    }

    if (couponCode != null && couponCode!.isNotEmpty) {
      data['couponCode'] = couponCode ?? "";
    }
    if (couponCodeAmount != null) {
      data['couponCodeAmount'] = couponCodeAmount ?? 0;
    }
    if (subTotal != null) {
      data['subTotal'] = subTotal ?? 0;
    }
    if (taxesCharges != null && taxesCharges!.isNotEmpty) {
      data['taxes_Charges'] = taxesCharges ?? "";
    }
    if (taxChargesAmount != null && taxChargesAmount!.isNotEmpty) {
      data['taxes_Charges_amount'] = taxChargesAmount ?? "";
    }
    if (totalAmount != null) {
      data['totalAmount'] = totalAmount ?? 0;
    }
    if (address != null) {
      data['address'] = address?.toJson();
    }
    return data;
  }

  static String encode(Cart cart) => jsonEncode(cart.toJson());

  static Cart decode(String cart) => Cart.fromJson(jsonDecode(cart));

  // static Cart decode(String cart) {
  //   var data = jsonDecode(cart);
  //   var cartModel = Cart.fromJson(data);

  //   return cartModel;
  // }
}
