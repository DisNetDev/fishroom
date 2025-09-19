// ignore_for_file: use_build_context_synchronously

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/check_and_set_pro.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/core/widgets/pricing_option_card.dart';
import 'package:fishroom/features/IAP/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../app/cubit/app_cubit.dart';

class UpgradeToPro extends StatefulWidget {
  const UpgradeToPro({super.key});

  @override
  State<UpgradeToPro> createState() => _UpgradeToProState();
}

class _UpgradeToProState extends State<UpgradeToPro> {
  bool isLoading = false;
  bool canMakePayments = false;
  PurchaseService purchaseService = PurchaseService();

  Future<void> init() async {
    PurchaseService().onPurchasingChanged = (isPurchasing) {
      if (isPurchasing) {
        fishLog("Purchasing started...");
        setState(() => isLoading = true);
      } else {
        fishLog("Purchasing finished.");
        setState(() => isLoading = false);
      }
    };
    try {
      canMakePayments = purchaseService.isAvailable;
    } catch (e) {
      setState(() => isLoading = false);
      showToast(context,
          title: "Failed to load subscriptions",
          description: e.toString(),
          toastType: ToastType.error);
    }
  }

  @override
  void initState() {
    init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(flex: 2, child: SizedBox()),
                  const Logo(horizontal: false),
                  const Expanded(flex: 2, child: SizedBox()),
                  const Text(
                    "Upgrade to Pro to get these bonuses:",
                    style: kHeading1TextStyle,
                    textAlign: TextAlign.center,
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                  _BenefitWidget(title: "Unlimited Tanks"),
                  _BenefitWidget(title: "Attach photos to your tank readings"),
                  const Expanded(flex: 2, child: SizedBox()),
                  const Gap(10),
                  !isLoading
                      ? BlocBuilder<AppCubit, AppState>(
                          builder: (blocContext, blocState) {
                            return Column(
                              spacing: 10,
                              children: purchaseService.products
                                  .where((test) => test.type == ProductType.sub)
                                  .map((e) => PricingOptionCard(
                                      title: toBeginningOfSentenceCase(
                                          e.title ?? ""),
                                      description: e.subtitle ?? "",
                                      price: e.productDetails?.price ?? "",
                                      onPressed: () async {
                                        try {
                                          setState(() => isLoading = true);
                                          if (e.productDetails != null) {
                                            purchaseService.buySubscription(
                                              e.productDetails!,
                                              onSuccess: () async {
                                                await checkAndSetPro(context);
                                                navPop(context);
                                              },
                                            );
                                          } else {
                                            showToast(context,
                                                title: "Error",
                                                description:
                                                    "Product details not found",
                                                toastType: ToastType.error);
                                          }
                                        } catch (e) {
                                          showToast(context,
                                              title: "Something went wrong",
                                              toastType: ToastType.error,
                                              description: e.toString());
                                        }
                                      }))
                                  .toList(),
                            );
                          },
                        )
                      : Loader(),
                  Gap(20),
                  if (!isLoading)
                    CustomButton(
                        loading: isLoading,
                        text: "Later",
                        primary: false,
                        onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BenefitWidget extends StatelessWidget {
  const _BenefitWidget({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check, color: kPrimaryColor),
        const Gap(10),
        Text(title),
      ],
    );
  }
}
