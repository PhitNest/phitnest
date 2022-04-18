class PurchaseModel {
  int transactionDate;
  String userID;
  String subscriptionPeriod;
  String receipt;
  String productId;
  String serverVerificationData;
  String source;
  bool active;

  PurchaseModel({
    this.transactionDate = 0,
    this.userID = '',
    this.subscriptionPeriod = '',
    this.receipt = '',
    this.productId = '',
    this.serverVerificationData = '',
    this.source = '',
    this.active = false,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> parsedJson) {
    return PurchaseModel(
      transactionDate: parsedJson['transactionDate'] ?? 0,
      userID: parsedJson['userID'] ?? '',
      subscriptionPeriod: parsedJson['subscriptionPeriod'] ?? '',
      receipt: parsedJson['receipt'] ?? '',
      productId: parsedJson['productId'] ?? '',
      serverVerificationData: parsedJson['serverVerificationData'] ?? '',
      source: parsedJson['source'] ?? '',
      active: parsedJson['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionDate': this.transactionDate,
      'userID': this.userID,
      'subscriptionPeriod': this.subscriptionPeriod,
      'receipt': this.receipt,
      'productId': this.productId,
      'serverVerificationData': this.serverVerificationData,
      'source': this.source,
      'active': this.active,
    };
  }
}
