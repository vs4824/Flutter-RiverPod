import 'dart:convert';

class Address {
  String? addressId;
  String? lat;
  String? lng;
  String? fullAddress;
  String? city;
  String? state;
  String? zipCode;
  String? addressLine1;

  Address({
    this.addressId,
    this.lat,
    this.lng,
    this.fullAddress,
    this.city,
    this.state,
    this.zipCode,
    this.addressLine1,
  });

  Address.fromJson(Map<String, dynamic> json) {
    addressId = json['addressId'];
    lat = json['lat'];
    lng = json['lng'];
    fullAddress = json['fullAddress'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipCode'];
    addressLine1 = json['addressLine1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    addressId = null;
    if (addressId != null || (addressId?.isNotEmpty ?? false)) {
      data['addressId'] = addressId ?? "";
    }

    data['lat'] = lat ?? "";
    data['lng'] = lng ?? "";
    data['fullAddress'] = fullAddress ?? "";
    data['city'] = city ?? "";
    data['state'] = state ?? "";
    data['zipCode'] = zipCode ?? "";
    data['addressLine1'] = addressLine1 ?? "";
    return data;
  }

  static String encode(Address add) => jsonEncode(add.toJson());

  static Address decode(String add) => Address.fromJson(jsonDecode(add));
}
