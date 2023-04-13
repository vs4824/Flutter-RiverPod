class MenuListModel {
  Data? data;
  int? code;
  String? message;

  MenuListModel({this.data, this.code, this.message});

  MenuListModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<Array>? array;
  int? count;
  List<Recommended>? recommended;

  Data({this.array, this.count, this.recommended});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['array'] != null) {
      array = <Array>[];
      json['array'].forEach((v) {
        array!.add(new Array.fromJson(v));
      });
    }
    count = json['count'];
    if (json['recommended'] != null) {
      recommended = <Recommended>[];
      json['recommended'].forEach((v) {
        recommended!.add(new Recommended.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.array != null) {
      data['array'] = this.array!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    if (this.recommended != null) {
      data['recommended'] = this.recommended!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Array {
  String? sId;
  List<MenuData>? menuData;
  List<Category>? category;

  Array({this.sId, this.menuData, this.category});

  Array.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['menu_data'] != null) {
      menuData = <MenuData>[];
      json['menu_data'].forEach((v) {
        menuData!.add(new MenuData.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.menuData != null) {
      data['menu_data'] = this.menuData!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuData {
  String? sId;
  String? userId;
  String? storeId;
  String? storeTypeId;
  String? foodCategoryId;
  String? itemCategoryId;
  String? cuisineCategoryId;
  String? itemName;
  String? lowerItemName;
  int? amount;
  String? amountIn;
  bool? recommended;
  String? preparationTime;
  String? timeIn;
  String? description;
  String? image;
  bool? storeTypeStatus;
  bool? cuisineCategoryStatus;
  bool? status;
  bool? addons;
  bool? itemSize;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;
  int? sizeAmount;
  String? foodCatId;
  List<Foodcategories>? foodcategories;
  List<AddonsList>? addonsList;
  List<VendorItemsizes>? vendorItemsizes;
  String? arItemName;
  String? arDescription;

  MenuData(
      {this.sId,
        this.userId,
        this.storeId,
        this.storeTypeId,
        this.foodCategoryId,
        this.itemCategoryId,
        this.cuisineCategoryId,
        this.itemName,
        this.lowerItemName,
        this.amount,
        this.amountIn,
        this.recommended,
        this.preparationTime,
        this.timeIn,
        this.description,
        this.image,
        this.storeTypeStatus,
        this.cuisineCategoryStatus,
        this.status,
        this.addons,
        this.itemSize,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt,
        this.sizeAmount,
        this.foodCatId,
        this.foodcategories,
        this.addonsList,
        this.vendorItemsizes,
        this.arItemName,
        this.arDescription});

  MenuData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    storeId = json['storeId'];
    storeTypeId = json['storeTypeId'];
    foodCategoryId = json['foodCategoryId'];
    itemCategoryId = json['itemCategoryId'];
    cuisineCategoryId = json['cuisineCategoryId'];
    itemName = json['itemName'];
    lowerItemName = json['lower_itemName'];
    amount = json['amount'];
    amountIn = json['amountIn'];
    recommended = json['recommended'];
    preparationTime = json['preparationTime'];
    timeIn = json['timeIn'];
    description = json['description'];
    image = json['image'];
    storeTypeStatus = json['storeType_status'];
    cuisineCategoryStatus = json['cuisineCategory_status'];
    status = json['status'];
    addons = json['addons'];
    itemSize = json['item_size'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sizeAmount = json['size_amount'];
    foodCatId = json['foodCatId'];
    if (json['foodcategories'] != null) {
      foodcategories = <Foodcategories>[];
      json['foodcategories'].forEach((v) {
        foodcategories!.add(new Foodcategories.fromJson(v));
      });
    }
    if (json['addons_list'] != null) {
      addonsList = <AddonsList>[];
      json['addons_list'].forEach((v) {
        addonsList!.add(new AddonsList.fromJson(v));
      });
    }
    if (json['vendor_itemsizes'] != null) {
      vendorItemsizes = <VendorItemsizes>[];
      json['vendor_itemsizes'].forEach((v) {
        vendorItemsizes!.add(new VendorItemsizes.fromJson(v));
      });
    }
    arItemName = json['ar_itemName'];
    arDescription = json['ar_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['storeId'] = this.storeId;
    data['storeTypeId'] = this.storeTypeId;
    data['foodCategoryId'] = this.foodCategoryId;
    data['itemCategoryId'] = this.itemCategoryId;
    data['cuisineCategoryId'] = this.cuisineCategoryId;
    data['itemName'] = this.itemName;
    data['lower_itemName'] = this.lowerItemName;
    data['amount'] = this.amount;
    data['amountIn'] = this.amountIn;
    data['recommended'] = this.recommended;
    data['preparationTime'] = this.preparationTime;
    data['timeIn'] = this.timeIn;
    data['description'] = this.description;
    data['image'] = this.image;
    data['storeType_status'] = this.storeTypeStatus;
    data['cuisineCategory_status'] = this.cuisineCategoryStatus;
    data['status'] = this.status;
    data['addons'] = this.addons;
    data['item_size'] = this.itemSize;
    data['isActive'] = this.isActive;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['size_amount'] = this.sizeAmount;
    data['foodCatId'] = this.foodCatId;
    if (this.foodcategories != null) {
      data['foodcategories'] =
          this.foodcategories!.map((v) => v.toJson()).toList();
    }
    if (this.addonsList != null) {
      data['addons_list'] = this.addonsList!.map((v) => v.toJson()).toList();
    }
    if (this.vendorItemsizes != null) {
      data['vendor_itemsizes'] =
          this.vendorItemsizes!.map((v) => v.toJson()).toList();
    }
    data['ar_itemName'] = this.arItemName;
    data['ar_description'] = this.arDescription;
    return data;
  }
}

class Foodcategories {
  String? sId;
  String? title;
  String? lowerTitle;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;

  Foodcategories(
      {this.sId,
        this.title,
        this.lowerTitle,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt});

  Foodcategories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    lowerTitle = json['lower_title'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['lower_title'] = this.lowerTitle;
    data['isActive'] = this.isActive;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class AddonsList {
  String? sId;
  List<MenuData>? menuData;
  List<AddonsTypes>? addonsTypes;

  AddonsList({this.sId, this.menuData, this.addonsTypes});

  AddonsList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['menu_data'] != null) {
      menuData = <MenuData>[];
      json['menu_data'].forEach((v) {
        menuData!.add(new MenuData.fromJson(v));
      });
    }
    if (json['addonsTypes'] != null) {
      addonsTypes = <AddonsTypes>[];
      json['addonsTypes'].forEach((v) {
        addonsTypes!.add(new AddonsTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.menuData != null) {
      data['menu_data'] = this.menuData!.map((v) => v.toJson()).toList();
    }
    if (this.addonsTypes != null) {
      data['addonsTypes'] = this.addonsTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuDatas {
  String? sId;
  String? userId;
  String? itemId;
  String? addonsTypeId;
  String? title;
  String? lowerTitle;
  String? amount;
  String? amountIn;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;
  String? arTitle;

  MenuDatas(
      {this.sId,
        this.userId,
        this.itemId,
        this.addonsTypeId,
        this.title,
        this.lowerTitle,
        this.amount,
        this.amountIn,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt,
        this.arTitle});

  MenuDatas.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    itemId = json['itemId'];
    addonsTypeId = json['addons_typeId'];
    title = json['title'];
    lowerTitle = json['lower_title'];
    amount = json['amount'];
    amountIn = json['amountIn'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    arTitle = json['ar_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['itemId'] = this.itemId;
    data['addons_typeId'] = this.addonsTypeId;
    data['title'] = this.title;
    data['lower_title'] = this.lowerTitle;
    data['amount'] = this.amount;
    data['amountIn'] = this.amountIn;
    data['isActive'] = this.isActive;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['ar_title'] = this.arTitle;
    return data;
  }
}

class AddonsTypes {
  String? sId;
  String? userId;
  String? storeId;
  String? title;
  String? lowerTitle;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;

  AddonsTypes(
      {this.sId,
        this.userId,
        this.storeId,
        this.title,
        this.lowerTitle,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt});

  AddonsTypes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    storeId = json['storeId'];
    title = json['title'];
    lowerTitle = json['lower_title'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['storeId'] = this.storeId;
    data['title'] = this.title;
    data['lower_title'] = this.lowerTitle;
    data['isActive'] = this.isActive;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class VendorItemsizes {
  String? sId;
  String? itemSize;
  String? lowerItemSize;
  int? amount;
  String? amountIn;

  VendorItemsizes(
      {this.sId,
        this.itemSize,
        this.lowerItemSize,
        this.amount,
        this.amountIn});

  VendorItemsizes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    itemSize = json['item_size'];
    lowerItemSize = json['lower_item_Size'];
    amount = json['amount'];
    amountIn = json['amountIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['item_size'] = this.itemSize;
    data['lower_item_Size'] = this.lowerItemSize;
    data['amount'] = this.amount;
    data['amountIn'] = this.amountIn;
    return data;
  }
}

class Category {
  String? sId;
  String? storeTypeId;
  String? title;
  String? lowerTitle;
  String? addBy;
  String? arTitle;
  String? image;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.sId,
        this.storeTypeId,
        this.title,
        this.lowerTitle,
        this.addBy,
        this.arTitle,
        this.image,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    storeTypeId = json['storeTypeId'];
    title = json['title'];
    lowerTitle = json['lower_title'];
    addBy = json['addBy'];
    arTitle = json['ar_title'];
    image = json['image'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['storeTypeId'] = this.storeTypeId;
    data['title'] = this.title;
    data['lower_title'] = this.lowerTitle;
    data['addBy'] = this.addBy;
    data['ar_title'] = this.arTitle;
    data['image'] = this.image;
    data['isActive'] = this.isActive;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Recommended {
  String? sId;
  String? userId;
  String? storeId;
  String? storeTypeId;
  String? foodCategoryId;
  String? itemCategoryId;
  String? cuisineCategoryId;
  String? itemName;
  String? lowerItemName;
  int? amount;
  int? sizeAmount;
  String? amountIn;
  bool? recommended;
  String? preparationTime;
  String? timeIn;
  String? description;
  String? image;
  bool? storeTypeStatus;
  bool? cuisineCategoryStatus;
  bool? status;
  bool? addons;
  bool? itemSize;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;
  String? arDescription;
  String? arItemName;
  String? foodCatId;
  List<Foodcategories>? foodcategories;
  List<AddonsList>? addonsList;
  List<VendorItemsizes>? vendorItemsizes;
  List<Category>? category;

  Recommended(
      {this.sId,
        this.userId,
        this.storeId,
        this.storeTypeId,
        this.foodCategoryId,
        this.itemCategoryId,
        this.cuisineCategoryId,
        this.itemName,
        this.lowerItemName,
        this.amount,
        this.sizeAmount,
        this.amountIn,
        this.recommended,
        this.preparationTime,
        this.timeIn,
        this.description,
        this.image,
        this.storeTypeStatus,
        this.cuisineCategoryStatus,
        this.status,
        this.addons,
        this.itemSize,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt,
        this.arDescription,
        this.arItemName,
        this.foodCatId,
        this.foodcategories,
        this.addonsList,
        this.vendorItemsizes,
        this.category});

  Recommended.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    storeId = json['storeId'];
    storeTypeId = json['storeTypeId'];
    foodCategoryId = json['foodCategoryId'];
    itemCategoryId = json['itemCategoryId'];
    cuisineCategoryId = json['cuisineCategoryId'];
    itemName = json['itemName'];
    lowerItemName = json['lower_itemName'];
    amount = json['amount'];
    sizeAmount = json['size_amount'];
    amountIn = json['amountIn'];
    recommended = json['recommended'];
    preparationTime = json['preparationTime'];
    timeIn = json['timeIn'];
    description = json['description'];
    image = json['image'];
    storeTypeStatus = json['storeType_status'];
    cuisineCategoryStatus = json['cuisineCategory_status'];
    status = json['status'];
    addons = json['addons'];
    itemSize = json['item_size'];
    isActive = json['isActive'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    arDescription = json['ar_description'];
    arItemName = json['ar_itemName'];
    foodCatId = json['foodCatId'];
    if (json['foodcategories'] != null) {
      foodcategories = <Foodcategories>[];
      json['foodcategories'].forEach((v) {
        foodcategories!.add(new Foodcategories.fromJson(v));
      });
    }
    if (json['addons_list'] != null) {
      addonsList = <AddonsList>[];
      json['addons_list'].forEach((v) {
        addonsList!.add(new AddonsList.fromJson(v));
      });
    }
    if (json['vendor_itemsizes'] != null) {
      vendorItemsizes = <VendorItemsizes>[];
      json['vendor_itemsizes'].forEach((v) {
        vendorItemsizes!.add(new VendorItemsizes.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['storeId'] = this.storeId;
    data['storeTypeId'] = this.storeTypeId;
    data['foodCategoryId'] = this.foodCategoryId;
    data['itemCategoryId'] = this.itemCategoryId;
    data['cuisineCategoryId'] = this.cuisineCategoryId;
    data['itemName'] = this.itemName;
    data['lower_itemName'] = this.lowerItemName;
    data['amount'] = this.amount;
    data['size_amount'] = this.sizeAmount;
    data['amountIn'] = this.amountIn;
    data['recommended'] = this.recommended;
    data['preparationTime'] = this.preparationTime;
    data['timeIn'] = this.timeIn;
    data['description'] = this.description;
    data['image'] = this.image;
    data['storeType_status'] = this.storeTypeStatus;
    data['cuisineCategory_status'] = this.cuisineCategoryStatus;
    data['status'] = this.status;
    data['addons'] = this.addons;
    data['item_size'] = this.itemSize;
    data['isActive'] = this.isActive;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['ar_description'] = this.arDescription;
    data['ar_itemName'] = this.arItemName;
    data['foodCatId'] = this.foodCatId;
    if (this.foodcategories != null) {
      data['foodcategories'] =
          this.foodcategories!.map((v) => v.toJson()).toList();
    }
    if (this.addonsList != null) {
      data['addons_list'] = this.addonsList!.map((v) => v.toJson()).toList();
    }
    if (this.vendorItemsizes != null) {
      data['vendor_itemsizes'] =
          this.vendorItemsizes!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}