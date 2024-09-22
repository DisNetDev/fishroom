import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/constants.dart';

class BarSegment extends StatefulWidget {
  const BarSegment({super.key, this.value, this.color, this.tag});

  final double? value;
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
      animatedValue = widget.value ?? getRandomValue();
    });
  }

  double animatedValue = 0;
  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        AnimatedContainer(
          decoration: BoxDecoration(
            color: widget.color ?? Colors.red,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                isDarkTheme ? Colors.black87 : Colors.white,
                widget.color ?? Colors.red
              ],
            ),
          ),
          margin: const EdgeInsets.only(right: 5),
          curve: Curves.bounceOut,
          duration: const Duration(milliseconds: 1000),
          width: 20,
          height: animatedValue,
        ),
        Text(
          widget.tag ?? "NA",
          style: kDateTimeTextStyle.copyWith(fontStyle: FontStyle.normal),
        ),
      ],
    );
  }
}
