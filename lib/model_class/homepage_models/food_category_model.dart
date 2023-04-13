class FoodCategoryModel {
  String? sId;
  String? storeType;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? lowerName;
  String? image;
  String? updatedAt;
  String? arStoreType;

  FoodCategoryModel(
      {this.sId,
        this.storeType,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.lowerName,
        this.image,
        this.updatedAt,
        this.arStoreType});

  FoodCategoryModel.fromJson(Map<String, dynamic> json) {
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
