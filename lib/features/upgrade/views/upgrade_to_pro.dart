// ignore_for_file: use_build_context_synchronously

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_pro_user.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/features/bug_report/views/thank_you.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../IAP/iap_service.dart';
import '../../app/cubit/app_cubit.dart';

class UpgradeToPro extends StatefulWidget {
  const UpgradeToPro({super.key});

  @override
  State<UpgradeToPro> createState() => _UpgradeToProState();
}

class _UpgradeToProState extends State<UpgradeToPro> {
  bool isLoading = false;
  final IAPService iapService = IAPService.instance;

  @override
  void initState() {
    super.initState();
    iapService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          Container(
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
                CustomButton(
                    loading: isLoading,
                    text: "Later",
                    primary: false,
                    onPressed: () => Navigator.of(context).pop()),
                const Gap(10),
                CustomButton(
                  loading: isLoading,
                  text: "Upgrade",
                  onPressed: () async {
                    setState(() => isLoading = true);
                    try {
                      await iapService.buyPro(
                        onPurchaseSuccess: () async {
                          try {
                            setState(() => isLoading = true);
                            await context.read<AppCubit>().upgradeUserToPro();
                            setState(() => isLoading = false);
                          } catch (e) {
                            setState(() => isLoading = false);
                            showToast(context,
                                title: "Failed to upgrade",
                                description: e.toString(),
                                toastType: ToastType.error);
                            navPop(context);
                          }
                          if (isProUser(context)) {
                            navReplace(context, ThankYou(boughtPro: true));
                          } else {
                            showToast(context,
                                title: "Failed to upgrade",
                                description:
                                    "If your payment was successful, please contact support.",
                                toastType: ToastType.error);
                            navPop(context);
                          }
                        },
                      );
                      setState(() => isLoading = false);
                    } catch (e) {
                      setState(() => isLoading = false);
                      showToast(context,
                          title: "Failed to upgrade",
                          description:
                              "${e.toString()} Please contact support.",
                          toastType: ToastType.error);
                    }
                  },
                ),
                const Gap(40),
              ],
            ),
          ),
        ],
      ),
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
