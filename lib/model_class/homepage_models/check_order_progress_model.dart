class CheckOrderProgressModel {
  String? sId;
  double? distance;
  String? pickupDateTime;
  String? pickupTime;
  String? pickupDate;
  String? status;

  CheckOrderProgressModel(
      {this.sId,
        this.distance,
        this.pickupDateTime,
        this.pickupTime,
        this.pickupDate,
        this.status});

  CheckOrderProgressModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    distance = json['distance'];
    pickupDateTime = json['pickup_dateTime'];
    pickupTime = json['pickup_time'];
    pickupDate = json['pickup_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['distance'] = this.distance;
    data['pickup_dateTime'] = this.pickupDateTime;
    data['pickup_time'] = this.pickupTime;
    data['pickup_date'] = this.pickupDate;
    data['status'] = this.status;
    return data;
  }
}