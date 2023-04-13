class StatusList {
  String? status;
  String? dateAndTime;
  String? time;

  StatusList({this.status, this.dateAndTime, this.time});

  StatusList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    dateAndTime = json['dateAndTime'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['dateAndTime'] = dateAndTime;
    data['time'] = time;
    return data;
  }
}
