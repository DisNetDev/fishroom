import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UpgradeToPro extends StatelessWidget {
  const UpgradeToPro({super.key});

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
                const Logo(horizontal: true),
                const Expanded(flex: 2, child: SizedBox()),
                const Text("Upgrade to Pro to get these bonuses:",
                    style: kHeading1TextStyle),
                const Expanded(flex: 1, child: SizedBox()),
                const Text("Unlimited Tanks"),
                const Text("Attach photos to your tank readings"),
                const Expanded(flex: 2, child: SizedBox()),
                CustomButton(
                    text: "Later",
                    primary: false,
                    onPressed: () => Navigator.of(context).pop()),
                const Gap(10),
                CustomButton(
                    text: "Upgrade",
                    onPressed: () => showToast(context,
                        title: "TO IMPLEMENT", toastType: ToastType.error)),
                const Gap(40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
