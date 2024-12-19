import 'dart:math';

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/features/tank_reading/models/parameter.dart';
import 'package:flutter/material.dart';

import '../../../core/models/tank_reading.dart';

class TankEntryGraph extends StatelessWidget {
  const TankEntryGraph({super.key, required this.tankReading});

  final TankReading tankReading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...tankReading.parameters.map((e) => _BottomBar(parameter: e)),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.parameter});

  final Parameter parameter;

  @override
  Widget build(BuildContext context) {
    double height = (parameter.value ?? 0) / (parameter.max ?? 0) * 75;
    if (height == 0) {
      height = 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            parameter.value.toString(),
            style: kDateTimeTextStyle.copyWith(
              fontSize: 11,
            ),
          ),
          Container(
            height: height,
            width: 15,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [kPrimaryColor, kSecondaryColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(3),
              ),
            ),
          ),
          Text(
            parameter.shortName ?? "",
            style: kDateTimeTextStyle.copyWith(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

Color getRandomColor() {
  final List<Color> predefinedColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.cyan,
    Colors.teal,
    Colors.amber,
  ];
  final Random random = Random();

  return predefinedColors[random.nextInt(predefinedColors.length)];
}
