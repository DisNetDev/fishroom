// ignore_for_file: use_build_context_synchronously

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/core/widgets/pricing_option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../app/cubit/app_cubit.dart';

class UpgradeToPro extends StatefulWidget {
  const UpgradeToPro({super.key});

  @override
  State<UpgradeToPro> createState() => _UpgradeToProState();
}

class _UpgradeToProState extends State<UpgradeToPro> {
  bool isLoading = false;
  bool canMakePayments = false;

  Future<void> init() async {
    try {
      canMakePayments = await Purchases.canMakePayments();
      setState(() => isLoading = true);
      await context.read<AppCubit>().getSubscriptions();
      setState(() => isLoading = false);
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
                          builder: (context, state) {
                            return Column(
                              spacing: 10,
                              children: state.availableSubscriptions
                                  .map((e) => PricingOptionCard(
                                      title: toBeginningOfSentenceCase(
                                          e.packageType.name),
                                      description: e.packageType.name ==
                                              "annual"
                                          ? "Renewed Annually.\nGet 2 Months Free."
                                          : "Renewed every month",
                                      price: e.storeProduct.priceString,
                                      onPressed: () async {
                                        try {
                                          setState(() => isLoading = true);
                                          await Purchases.purchasePackage(e);
                                          await context
                                              .read<AppCubit>()
                                              .upgradeUserToPro();
                                          navPop(context);
                                        } catch (e) {
                                          setState(() => isLoading = false);
                                          if (e
                                              .toString()
                                              .contains("cancelled")) {
                                            return;
                                          }
                                          showToast(context,
                                              title:
                                                  "Error purchasing subscription",
                                              description: e.toString(),
                                              toastType: ToastType.error);
                                        }
                                      }))
                                  .toList(),
                            );
                          },
                        )
                      : Loader(),
                  Gap(20),
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
