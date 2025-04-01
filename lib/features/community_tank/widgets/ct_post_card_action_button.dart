import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants.dart';

class CTPActionButton extends StatelessWidget {
  const CTPActionButton(
      {super.key,
      required this.count,
      required this.icon,
      required this.onTap,
      required this.color});

  final int count;
  final IconData icon;
  final Color color;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kPrimaryColor,
      radius: 5,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
            opticalSize: 20,
          ),
          Gap(5),
          Text(count.toString(),
              style: kDateTimeTextStyle.copyWith(fontSize: 12)),
          Gap(10),
        ],
      ),
    );
  }
}
