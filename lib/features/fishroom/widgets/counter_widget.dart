import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants.dart';

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
        child: Column(
          children: [
            Text(
              heading,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kHeading2TextStyle,
            ),
            Gap(5),
            if (icon != null) icon!,
            Gap(5),
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
