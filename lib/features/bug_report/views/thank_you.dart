import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/usecases/nav_push.dart';
import '../../../core/widgets/custom_background.dart';
import '../../../core/widgets/custom_button.dart';

class ThankYou extends StatelessWidget {
  const ThankYou({super.key, this.boughtPro = false});

  final bool boughtPro;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: SizedBox()),
                Text(
                  !boughtPro
                      ? "Thank you for your report!"
                      : "Thank you for your purchase!",
                  style: kHeadingTextStyle,
                  textAlign: TextAlign.center,
                ),
                Gap(20),
                Text(
                  !boughtPro
                      ? "The developer will be notified and will contact you if needed."
                      : "You now have access to the Pro version of Fishroom.\nThis includes adding unlimited tanks, and attaching photos to you tank readings!",
                  style: kPlainTextStyle,
                  textAlign: TextAlign.center,
                ),
                Expanded(child: SizedBox()),
                CustomButton(
                  text: "Back to your Fishroom",
                  onPressed: () => navPop(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
