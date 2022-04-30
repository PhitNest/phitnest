import 'package:display/display_utils.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../models/models.dart';
import '../../../../services/services.dart';
import '../../../screen_utils.dart';
import 'upgrade_account_model.dart';

class UpgradeAccountFunctions {
  final BuildContext context;
  final UserModel user;
  final UpgradeAccountModel model;

  UpgradeAccountFunctions(
      {required this.context, required this.user, required this.model}) {
    _initStoreInfo();
  }

  Widget upgradeAccount() {
    List<Widget> stack = [];
    if (model.queryProductError == null) {
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
          child: Text(model.queryProductError!),
        ),
      ));
    }
    if (model.purchasePending) {
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
                    color: DisplayUtils.isDarkMode ? Colors.black12 : null,
                  ),
                  Image.asset(
                    'assets/images/premium_account_2.png',
                    colorBlendMode: BlendMode.srcOver,
                    color: DisplayUtils.isDarkMode ? Colors.black12 : null,
                  ),
                  Image.asset(
                    'assets/images/premium_account_3.png',
                    colorBlendMode: BlendMode.srcOver,
                    color: DisplayUtils.isDarkMode ? Colors.black12 : null,
                  ),
                  Image.asset(
                    'assets/images/premium_account_4.png',
                    colorBlendMode: BlendMode.srcOver,
                    color: DisplayUtils.isDarkMode ? Colors.black12 : null,
                  ),
                  Image.asset(
                    'assets/images/premium_account_5.png',
                    colorBlendMode: BlendMode.srcOver,
                    color: DisplayUtils.isDarkMode ? Colors.black12 : null,
                  )
                ],
                controller: model.controller,
              ),
            ),
            Positioned(
              bottom: 8,
              child: SmoothPageIndicator(
                controller: model.controller,
                count: 5,
                effect: ScrollingDotsEffect(
                    dotWidth: 6,
                    dotHeight: 6,
                    dotColor:
                        DisplayUtils.isDarkMode ? Colors.grey : Colors.black54,
                    activeDotColor: Color(COLOR_PRIMARY)),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Go VIP',
            style: TextStyle(fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'When you subscribe, you get unlimited daily swipes,undo action, '
            'VIP badge and more.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DisplayUtils.isDarkMode ? Colors.white54 : Colors.black45,
            ),
          ),
        ),
        Stack(
          children: stack,
        )
      ],
    );
  }

  Future<void> _initStoreInfo() async {
    final bool isAvailable = await model.connection.isAvailable();
    print('_UpgradeAccountState.initStoreInfo $isAvailable');
    if (!isAvailable) {
      model.initInfo(isAvailable);
      return;
    }

    ProductDetailsResponse productDetailResponse = await model.connection
        .queryProductDetails(
            <String>{MONTHLY_SUBSCRIPTION, YEARLY_SUBSCRIPTION});
    if (productDetailResponse.error != null) {
      model.setError(isAvailable, productDetailResponse);
      return;
    }

    //getting empty product list here
    print('products ${productDetailResponse.productDetails.length}');

    if (productDetailResponse.productDetails.isEmpty) {
      model.initEmpty(isAvailable, productDetailResponse);
      return;
    }

    await model.connection.restorePurchases();
    final List<PurchaseDetails> verifiedPurchases = [];
    model.connection.purchaseStream.listen((event) async {
      for (PurchaseDetails purchase in event) {
        if (await _verifyPurchase(purchase)) {
          await _handlePurchase(purchase);
          verifiedPurchases.add(purchase);
        }
      }
    });

    model.initProducts(isAvailable, productDetailResponse, verifiedPurchases);
  }

  Card _buildConnectionCheckTile() {
    if (model.loading) {
      return Card(child: ListTile(title: Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(model.isAvailable ? Icons.check : Icons.block,
          color:
              model.isAvailable ? Colors.green : ThemeData.light().errorColor),
      title: Text('The store is ' +
          (model.isAvailable ? 'available' : 'unavailable') +
          '.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!model.isAvailable) {
      children.addAll([
        Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: Text(
              'Unable to connect to the payments processor. Has this app been configured correctly?'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Card _buildProductList() {
    if (model.loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator.adaptive(),
              title: Text('Fetching products...'))));
    }
    if (!model.isAvailable) {
      return Card();
    }
    final ListTile productHeader = ListTile(title: Text('Products for Sale'));
    List<ListTile> productList = <ListTile>[];
    if (model.notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${model.notFoundIds.join(', ')}] not found',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: Text('This app needs special configuration to run.')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verity the purchase data.
    Map<String, PurchaseDetails> purchases =
        Map.fromEntries(model.purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(
      model.products.map(
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
                      await model.connection
                          .buyNonConsumable(purchaseParam: purchaseParam);
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
      BackEndModel backEnd = BackEndModel.getBackEnd(context);
      await DialogUtils.showProgress(context, 'Processing purchase...', false);
      await backEnd.recordPurchase(purchase);
      await DialogUtils.hideProgress();
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }
}
