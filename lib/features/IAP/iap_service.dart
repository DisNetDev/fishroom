import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/usecases/log.dart';

class IAPService {
  IAPService._();

  static final IAPService _instance = IAPService._();

  static IAPService get instance => _instance;

  final InAppPurchase _iap = InAppPurchase.instance;

  late StreamSubscription<List<PurchaseDetails>> _purchasesSubscription;

  Future<void> initialize() async {
    fishLog("Initializing IAP");
    if (!(await _iap.isAvailable())) {
      fishLog("IAP not available");
      throw Exception("Store not available");
    }

    fishLog("IAP available");

    _purchasesSubscription = InAppPurchase.instance.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () {
        _purchasesSubscription.cancel();
      },
      onError: (error) {
        throw Exception(error);
      },
    );
    fishLog("IAP initialized");
  }

  void handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (int index = 0; index < purchaseDetailsList.length; index++) {
      var purchaseStatus = purchaseDetailsList[index].status;
      switch (purchaseDetailsList[index].status) {
        case PurchaseStatus.pending:
          fishLog(' Pending Purchase ');
          continue;
        case PurchaseStatus.error:
          fishLog(' Purchase Error ');
          break;
        case PurchaseStatus.canceled:
          fishLog(' Purchase Canceled ');
          break;
        case PurchaseStatus.purchased:
          fishLog(' Purchase Success ');
          break;
        case PurchaseStatus.restored:
          fishLog(' Purchase Restored ');
          break;
      }

      if (purchaseDetailsList[index].pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetailsList[index]).then(
          (value) {
            if (purchaseStatus == PurchaseStatus.purchased) {
              fishLog("Woah! Purchase Success!");
            }
          },
        );
      }
    }
  }

  Future<void> buyPro() async {
    try {
      if (!(await _iap.isAvailable())) {
        fishLog("IAP not available");
        throw Exception("Store not available");
      }

      final ProductDetailsResponse productDetailsResponse =
          await _iap.queryProductDetails({"pro_version"});

      if (productDetailsResponse.productDetails.isEmpty) {
        throw Exception('Product not found');
      }

      final PurchaseParam purchaseParam = PurchaseParam(
          productDetails: productDetailsResponse.productDetails.first);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (_) {
      rethrow;
    }
  }
}
