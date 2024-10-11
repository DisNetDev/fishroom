import 'dart:math';

import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants.dart';

class BarSegment extends StatefulWidget {
  const BarSegment({super.key, this.value, this.color, this.tag, this.height});

  final double? value;
  final double? height;
  final Color? color;
  final String? tag;

  @override
  State<BarSegment> createState() => _BarSegmentState();
}

class _BarSegmentState extends State<BarSegment> {
  double getRandomValue() {
    return Random().nextDouble() * 49 + 1;
  }

  @override
  void initState() {
    super.initState();
    animate();
  }

  animate() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      animatedValue = widget.height ?? getRandomValue();
    });
  }

  double animatedValue = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.value.toString(),
          style: kDateTimeTextStyle.copyWith(
              fontStyle: FontStyle.italic, color: Colors.grey),
        ),
        const Gap(5),
        AnimatedContainer(
          decoration: BoxDecoration(
            color: widget.color ?? Colors.red,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                isDarkMode(context) ? Colors.black87 : Colors.white,
                widget.color ?? Colors.red
              ],
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          curve: Curves.bounceOut,
          duration: const Duration(milliseconds: 1000),
          width: 20,
          height: animatedValue,
        ),
        Text(
          widget.tag ?? "NA",
          style: kDateTimeTextStyle.copyWith(
              fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
