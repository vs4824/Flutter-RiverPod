class Addons {
  String? addonsId;
  String? addonsTypeId;
  String? addonsName;
  num? perAddonsPrice;
  int? quantity;
  num? addonsPrice;

  Addons({
    this.addonsId,
    this.addonsTypeId,
    this.addonsName,
    this.perAddonsPrice,
    this.quantity,
    this.addonsPrice,
  });

  Addons.fromJson(Map<String, dynamic> json) {
    addonsId = json['addonsId'];
    addonsTypeId = json['addonsTypeId'];
    addonsName = json['addonsName'];
    perAddonsPrice = json['perAddonsPrice'];
    quantity = json['quantity'];
    addonsPrice = json['addonsPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addonsId'] = addonsId;
    data['addonsTypeId'] = addonsTypeId;
    data['addonsName'] = addonsName;
    data['perAddonsPrice'] = perAddonsPrice;
    data['quantity'] = quantity;
    data['addonsPrice'] = addonsPrice;
    return data;
  }

  @override
  String toString() =>
      "Addons: {addonsId: $addonsId, addonsTypeId: $addonsTypeId}, addonsName:$addonsName,";
}
