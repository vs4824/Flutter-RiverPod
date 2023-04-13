class FoodCategoryListModel {
  String? sId;
  String? title;
  String? lowerTitle;
  bool? isActive;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;

  FoodCategoryListModel(
      {this.sId,
        this.title,
        this.lowerTitle,
        this.isActive,
        this.isDelete,
        this.createdAt,
        this.updatedAt});

  FoodCategoryListModel.fromJson(Map<String, dynamic> json) {
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