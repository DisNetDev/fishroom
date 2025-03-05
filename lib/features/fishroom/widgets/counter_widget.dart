import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../../core/constants.dart';
import '../../../core/usecases/is_dark_mode.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget(
      {super.key,
      required this.heading,
      required this.counter,
      this.icon,
      this.onTap});

  final String heading;
  final int counter;
  final Widget? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color:
                isDarkMode(context) ? Colors.transparent : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: GradientBoxBorder(gradient: kPrimaryGradient)),
        child: Column(
          children: [
            Text(
              heading,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kHeading2TextStyle,
            ),
            Gap(10),
            if (icon != null) icon!,
            Gap(10),
            Text(
              counter.toString(),
              style: kHeadingTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
