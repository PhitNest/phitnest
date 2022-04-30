import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class UpgradeAccountModel extends ChangeNotifier {
  List<String> notFoundIds = [];
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];
  bool isAvailable = false;
  bool purchasePending = false;
  bool loading = true;
  String? queryProductError;
  final InAppPurchase connection = InAppPurchase.instance;
  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initInfo(bool availability) {
    isAvailable = availability;
    products = [];
    purchases = [];
    notFoundIds = [];
    purchasePending = false;
    loading = false;
    notifyListeners();
  }

  void setError(bool availability, ProductDetailsResponse response) {
    queryProductError = response.error!.message;
    isAvailable = availability;
    products = response.productDetails;
    purchases = [];
    notFoundIds = response.notFoundIDs;
    purchasePending = false;
    loading = false;
    notifyListeners();
  }

  void initEmpty(bool availability, ProductDetailsResponse response) {
    queryProductError = null;
    isAvailable = availability;
    products = response.productDetails;
    purchases = [];
    notFoundIds = response.notFoundIDs;
    purchasePending = false;
    loading = false;
    notifyListeners();
  }

  void initProducts(bool availability, ProductDetailsResponse response,
      List<PurchaseDetails> purchases) {
    isAvailable = availability;
    products = response.productDetails;
    purchases = purchases;
    notFoundIds = response.notFoundIDs;
    purchasePending = false;
    loading = false;
    notifyListeners();
  }
}
