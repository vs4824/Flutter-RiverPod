class FetchOffers {
  String? sId;
  String? image;
  String? couponCode;
  String? offerType;
  int? offerAmount;
  int? minimumAmount;
  int? uptoAmount;
  String? expiryDate;

  FetchOffers(
      {this.sId,
        this.image,
        this.couponCode,
        this.offerType,
        this.offerAmount,
        this.minimumAmount,
        this.uptoAmount,
        this.expiryDate});

  FetchOffers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    couponCode = json['couponCode'];
    offerType = json['offer_type'];
    offerAmount = json['offer_amount'];
    minimumAmount = json['minimum_amount'];
    uptoAmount = json['upto_Amount'];
    expiryDate = json['expiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['image'] = this.image;
    data['couponCode'] = this.couponCode;
    data['offer_type'] = this.offerType;
    data['offer_amount'] = this.offerAmount;
    data['minimum_amount'] = this.minimumAmount;
    data['upto_Amount'] = this.uptoAmount;
    data['expiryDate'] = this.expiryDate;
    return data;
  }
}