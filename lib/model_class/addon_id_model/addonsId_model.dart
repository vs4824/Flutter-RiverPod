class AddonId {
  String? addonsId;

  AddonId({this.addonsId});

  AddonId.fromJson(Map<String, dynamic> json) {
    addonsId = json['addonsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addonsId'] = addonsId;
    return data;
  }
}
