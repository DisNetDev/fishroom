import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../../core/constants.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget(
      {super.key, required this.heading, required this.counter});

  final String heading;
  final int counter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: GradientBoxBorder(gradient: kPrimaryGradient)),
      child: Column(
        children: [
          Text(
            heading,
            textAlign: TextAlign.center,
            style: kHeading1TextStyle,
          ),
          Gap(20),
          Text(
            counter.toString(),
            style: kHeadingTextStyle,
          )
        ],
      ),
    );
  }
}
