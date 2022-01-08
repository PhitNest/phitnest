import 'package:dating/constants.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UpgradeAccount extends StatefulWidget {
  @override
  _UpgradeAccountState createState() => _UpgradeAccountState();
}

class _UpgradeAccountState extends State<UpgradeAccount> {
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  final InAppPurchase _connection = InAppPurchase.instance;
  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    initStoreInfo();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * .85,
        decoration: BoxDecoration(
          color: isDarkMode(context) ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: _upgradeAccount());
  }

  Widget _upgradeAccount() {
    List<Widget> stack = [];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          shrinkWrap: true,
          children: [
            _buildConnectionCheckTile(),
            _buildProductList(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_queryProductError!),
        ),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: const ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 200,
              child: PageView(
                children: [
                  Image.asset(
                    'assets/images/premium_account_1.png',
                    colorBlendMode: BlendMode.srcOver,
                    color: isDarkMode(context) ? Colors.black12 : null,
                  ),
                  Image.asset(
                    'assets/images/premium_account_2.png',
                    colorBlendMode: BlendMode.srcOver,
                    color: isDarkMode(context) ? Colors.black12 : null,
                  ),
                  Image.asset(
                    'assets/images/premium_account_3.png',
                    colorBlendMode: BlendMode.srcOver,
                    color: isDarkMode(context) ? Colors.black12 : null,
                  ),
                  Image.asset(
                    'assets/images/premium_account_4.png',
                    colorBlendMode: BlendMode.srcOver,
                    color: isDarkMode(context) ? Colors.black12 : null,
                  ),
                  Image.asset(
                    'assets/images/premium_account_5.png',
                    colorBlendMode: BlendMode.srcOver,
                    color: isDarkMode(context) ? Colors.black12 : null,
                  )
                ],
                controller: controller,
              ),
            ),
            Positioned(
              bottom: 8,
              child: SmoothPageIndicator(
                controller: controller,
                count: 5,
                effect: ScrollingDotsEffect(
                    dotWidth: 6,
                    dotHeight: 6,
                    dotColor:
                        isDarkMode(context) ? Colors.grey : Colors.black54,
                    activeDotColor: Color(COLOR_PRIMARY)),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Go VIP'.tr(),
            style: TextStyle(fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'When you subscribe, you get unlimited daily swipes,undo action, '
                    'VIP badge and more.'
                .tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDarkMode(context) ? Colors.white54 : Colors.black45,
            ),
          ),
        ),
        Stack(
          children: stack,
        )
      ],
    );
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    print('_UpgradeAccountState.initStoreInfo $isAvailable');
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse = await _connection
        .queryProductDetails(
            <String>{MONTHLY_SUBSCRIPTION, YEARLY_SUBSCRIPTION});
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    //getting empty product list here
    print('products ${productDetailResponse.productDetails.length}');

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    await _connection.restorePurchases();
    final List<PurchaseDetails> verifiedPurchases = [];
    _connection.purchaseStream.listen((event) async {
      for (PurchaseDetails purchase in event) {
        if (await verifyPurchase(purchase)) {
          await _handlePurchase(purchase);
          verifiedPurchases.add(purchase);
        }
      }
    });

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
    });
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return Card(child: ListTile(title: Text('Trying to connect...'.tr())));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
      title: Text('The store is '.tr() +
          (_isAvailable ? 'available'.tr() : 'unavailable'.tr()) +
          '.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll([
        Divider(),
        ListTile(
          title: Text('Not connected'.tr(),
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: Text(
              'Unable to connect to the payments processor. Has this app been configured correctly?'
                  .tr()),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Card _buildProductList() {
    if (_loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator.adaptive(),
              title: Text('Fetching products...'.tr()))));
    }
    if (!_isAvailable) {
      return Card();
    }
    final ListTile productHeader =
        ListTile(title: Text('Products for Sale'.tr()));
    List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(', ')}] not found'.tr(),
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: Text('This app needs special configuration to run.'.tr())));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verity the purchase data.
    Map<String, PurchaseDetails> purchases =
        Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(
      _products.map(
        (ProductDetails productDetails) {
          PurchaseDetails? previousPurchase = purchases[productDetails.id];
          return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: previousPurchase != null
                ? Icon(Icons.check)
                : TextButton(
                    style: TextButton.styleFrom(primary: Colors.green.shade800),
                    child: Text(
                      productDetails.price,
                      style: TextStyle(color: Colors.white),
                    ),
              onPressed: () async {
                      PurchaseParam purchaseParam = PurchaseParam(
                          productDetails: productDetails,
                          applicationUserName: null);
                      await _connection.buyNonConsumable(
                          purchaseParam: purchaseParam);
                    },
                  ),
          );
        },
      ),
    );

    return Card(
        child:
            Column(children: <Widget>[productHeader, Divider()] + productList));
  }

  _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased) {
      await showProgress(context, 'Processing purchase...'.tr(), false);
      await FireStoreUtils.recordPurchase(purchase);
      await hideProgress();
    }
  }
}

Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) {
  // IMPORTANT!! Always verify a purchase before delivering the product.
  // For the purpose of an example, we directly return true.
  return Future<bool>.value(true);
}
