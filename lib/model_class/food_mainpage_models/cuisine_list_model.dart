class CuisineListModel {
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

  CuisineListModel(
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

  CuisineListModel.fromJson(Map<String, dynamic> json) {
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