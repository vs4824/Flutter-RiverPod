class FoodOffersModel {
  String? sId;
  String? addBy;
  String? image;
  String? couponCode;
  String? title;
  String? description;
  String? offerType;
  int? offerAmount;
  String? startDate;
  String? arTitle;
  String? arDescription;
  int? minimumAmount;
  int? uptoAmount;
  String? expiryDate;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;
  List<Storetypes>? storetypes;
  List<Vendorstores>? vendorstores;
  StoreTypeId? storeTypeId;

  FoodOffersModel(
      {this.sId,
        this.addBy,
        this.image,
        this.couponCode,
        this.title,
        this.description,
        this.offerType,
        this.offerAmount,
        this.startDate,
        this.arTitle,
        this.arDescription,
        this.minimumAmount,
        this.uptoAmount,
        this.expiryDate,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt,
        this.storetypes,
        this.vendorstores,
        this.storeTypeId});

  FoodOffersModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    addBy = json['addBy'];
    image = json['image'];
    couponCode = json['couponCode'];
    title = json['title'];
    description = json['description'];
    offerType = json['offer_type'];
    offerAmount = json['offer_amount'];
    startDate = json['startDate'];
    arTitle = json['ar_title'];
    arDescription = json['ar_description'];
    minimumAmount = json['minimum_amount'];
    uptoAmount = json['upto_Amount'];
    expiryDate = json['expiryDate'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['storetypes'] != null) {
      storetypes = <Storetypes>[];
      json['storetypes'].forEach((v) {
        storetypes!.add(new Storetypes.fromJson(v));
      });
    }
    if (json['vendorstores'] != null) {
      vendorstores = <Vendorstores>[];
      json['vendorstores'].forEach((v) {
        vendorstores!.add(new Vendorstores.fromJson(v));
      });
    }
    storeTypeId = json['storeTypeId'] != null
        ? new StoreTypeId.fromJson(json['storeTypeId'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['addBy'] = this.addBy;
    data['image'] = this.image;
    data['couponCode'] = this.couponCode;
    data['title'] = this.title;
    data['description'] = this.description;
    data['offer_type'] = this.offerType;
    data['offer_amount'] = this.offerAmount;
    data['startDate'] = this.startDate;
    data['ar_title'] = this.arTitle;
    data['ar_description'] = this.arDescription;
    data['minimum_amount'] = this.minimumAmount;
    data['upto_Amount'] = this.uptoAmount;
    data['expiryDate'] = this.expiryDate;
    data['isActive'] = this.isActive;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.storetypes != null) {
      data['storetypes'] = this.storetypes!.map((v) => v.toJson()).toList();
    }
    if (this.vendorstores != null) {
      data['vendorstores'] = this.vendorstores!.map((v) => v.toJson()).toList();
    }
    if (this.storeTypeId != null) {
      data['storeTypeId'] = this.storeTypeId!.toJson();
    }
    return data;
  }
}

class Storetypes {
  String? sId;
  String? storeType;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? lowerName;
  String? image;
  String? updatedAt;
  String? arStoreType;

  Storetypes(
      {this.sId,
        this.storeType,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.lowerName,
        this.image,
        this.updatedAt,
        this.arStoreType});

  Storetypes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    storeType = json['storeType'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    lowerName = json['lower_name'];
    image = json['image'];
    updatedAt = json['updatedAt'];
    arStoreType = json['ar_storeType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['storeType'] = this.storeType;
    data['isActive'] = this.isActive;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    data['lower_name'] = this.lowerName;
    data['image'] = this.image;
    data['updatedAt'] = this.updatedAt;
    data['ar_storeType'] = this.arStoreType;
    return data;
  }
}

class Vendorstores {
  String? sId;
  String? userId;
  String? image;
  String? branchName;
  String? fullAddress;
  var rating;
  bool? onlineStatus;
  int? hightItemAmount;
  double? lat;
  double? lng;
  bool? isActive;
  String? arBranchName;
  List<double>? location;
  List<Cuisinee>? cuisinee;
  double? dictance;
  bool? favourite;
  Offer? offer;
  String? vendorId;
  bool? nearRestaurantAvailable;

  Vendorstores(
      {this.sId,
        this.userId,
        this.image,
        this.branchName,
        this.fullAddress,
        this.rating,
        this.onlineStatus,
        this.hightItemAmount,
        this.lat,
        this.lng,
        this.isActive,
        this.arBranchName,
        this.location,
        this.cuisinee,
        this.dictance,
        this.favourite,
        this.offer,
        this.vendorId,
        this.nearRestaurantAvailable});

  Vendorstores.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    image = json['image'];
    branchName = json['branchName'];
    fullAddress = json['fullAddress'];
    rating = json['rating'];
    onlineStatus = json['online_status'];
    hightItemAmount = json['hightItemAmount'];
    lat = json['lat'];
    lng = json['lng'];
    isActive = json['isActive'];
    arBranchName = json['ar_branchName'];
    location = json['location'].cast<double>();
    if (json['cuisinee'] != null) {
      cuisinee = <Cuisinee>[];
      json['cuisinee'].forEach((v) {
        cuisinee!.add(new Cuisinee.fromJson(v));
      });
    }
    dictance = json['dictance'];
    favourite = json['favourite'];
    offer = json['offer'] != null ? new Offer.fromJson(json['offer']) : null;
    vendorId = json['vendorId'];
    nearRestaurantAvailable = json['near_restaurantAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['image'] = this.image;
    data['branchName'] = this.branchName;
    data['fullAddress'] = this.fullAddress;
    data['rating'] = this.rating;
    data['online_status'] = this.onlineStatus;
    data['hightItemAmount'] = this.hightItemAmount;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['isActive'] = this.isActive;
    data['ar_branchName'] = this.arBranchName;
    data['location'] = this.location;
    if (this.cuisinee != null) {
      data['cuisinee'] = this.cuisinee!.map((v) => v.toJson()).toList();
    }
    data['dictance'] = this.dictance;
    data['favourite'] = this.favourite;
    if (this.offer != null) {
      data['offer'] = this.offer!.toJson();
    }
    data['vendorId'] = this.vendorId;
    data['near_restaurantAvailable'] = this.nearRestaurantAvailable;
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

class StoreTypeId {
  String? sId;
  String? storeType;
  String? arStoreType;
  bool? isActive;

  StoreTypeId({this.sId, this.storeType, this.arStoreType, this.isActive});

  StoreTypeId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    storeType = json['storeType'];
    arStoreType = json['ar_storeType'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['storeType'] = this.storeType;
    data['ar_storeType'] = this.arStoreType;
    data['isActive'] = this.isActive;
    return data;
  }
}