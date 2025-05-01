class Money {
  int? moneyId;
  String? moneyDetail;
  String? moneyDate;
  double? moneyInOut;
  int? moneyType;
  int? userId;

  Money({
    this.moneyId,
    this.moneyDetail,
    this.moneyDate,
    this.moneyInOut,
    this.moneyType,
    this.userId,
  });

  Money.fromJson(Map<String, dynamic> json) {
    moneyId = json['moneyId'];
    moneyDetail = json['moneyDetail'];
    moneyDate = json['moneyDate'];
    moneyInOut = (json['moneyInOut'] as num?)?.toDouble();
    moneyType = json['moneyType'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['moneyId'] = this.moneyId;
    data['moneyDetail'] = this.moneyDetail;
    data['moneyDate'] = this.moneyDate;
    data['moneyInOut'] = this.moneyInOut;
    data['moneyType'] = this.moneyType;
    data['userId'] = this.userId;
    return data;
  }
}
