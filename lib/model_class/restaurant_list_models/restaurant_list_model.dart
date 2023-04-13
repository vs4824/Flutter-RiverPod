class FetchRestaurantListModel {
  String? sId;
  String? vendorId;
  String? branchName;
  String? fullAddress;
  String? city;
  String? image;
  double? rating;
  bool? favourite;
  bool? nearRestaurantAvailable;
  bool? isActive;
  bool? onlineStatus;
  int? hightItemAmount;
  Offer? offer;
  List<Cuisinee>? cuisinee;
  double? lat;
  double? lng;
  double? dictance;

  FetchRestaurantListModel(
      {this.sId,
        this.vendorId,
        this.branchName,
        this.fullAddress,
        this.city,
        this.image,
        this.rating,
        this.favourite,
        this.nearRestaurantAvailable,
        this.isActive,
        this.onlineStatus,
        this.hightItemAmount,
        this.offer,
        this.cuisinee,
        this.lat,
        this.lng,
        this.dictance});

  FetchRestaurantListModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    vendorId = json['vendorId'];
    branchName = json['branchName'];
    fullAddress = json['fullAddress'];
    city = json['city'];
    image = json['image'];
    rating = json['rating'];
    favourite = json['favourite'];
    nearRestaurantAvailable = json['near_restaurantAvailable'];
    isActive = json['isActive'];
    onlineStatus = json['online_status'];
    hightItemAmount = json['hightItemAmount'];
    offer = json['offer'] != null ? new Offer.fromJson(json['offer']) : null;
    if (json['cuisinee'] != null) {
      cuisinee = <Cuisinee>[];
      json['cuisinee'].forEach((v) {
        cuisinee!.add(new Cuisinee.fromJson(v));
      });
    }
    lat = json['lat'];
    lng = json['lng'];
    dictance = json['dictance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['vendorId'] = this.vendorId;
    data['branchName'] = this.branchName;
    data['fullAddress'] = this.fullAddress;
    data['city'] = this.city;
    data['image'] = this.image;
    data['rating'] = this.rating;
    data['favourite'] = this.favourite;
    data['near_restaurantAvailable'] = this.nearRestaurantAvailable;
    data['isActive'] = this.isActive;
    data['online_status'] = this.onlineStatus;
    data['hightItemAmount'] = this.hightItemAmount;
    if (this.offer != null) {
      data['offer'] = this.offer!.toJson();
    }
    if (this.cuisinee != null) {
      data['cuisinee'] = this.cuisinee!.map((v) => v.toJson()).toList();
    }
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['dictance'] = this.dictance;
    return data;
  }
}

class Offer {
  String? sId;
  String? offerType;
  int? offerAmount;
  String? expiryDate;

  Offer({this.sId, this.offerType, this.offerAmount, this.expiryDate});

  Offer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    offerType = json['offer_type'];
    offerAmount = json['offer_amount'];
    expiryDate = json['expiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['offer_type'] = this.offerType;
    data['offer_amount'] = this.offerAmount;
    data['expiryDate'] = this.expiryDate;
    return data;
  }
}

class Cuisinee {
  String? sId;
  String? title;
  String? arTitle;
  String? image;
  String? lowerTitle;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;
  String? storeTypeId;

  Cuisinee(
      {this.sId,
        this.title,
        this.arTitle,
        this.image,
        this.lowerTitle,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt,
        this.storeTypeId});

  Cuisinee.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    arTitle = json['ar_title'];
    image = json['image'];
    lowerTitle = json['lower_title'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    storeTypeId = json['storeTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['ar_title'] = this.arTitle;
    data['image'] = this.image;
    data['lower_title'] = this.lowerTitle;
    data['isActive'] = this.isActive;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['storeTypeId'] = this.storeTypeId;
    return data;
  }
}