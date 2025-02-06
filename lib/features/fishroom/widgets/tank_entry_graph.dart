import 'dart:math';

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:fishroom/features/tank_reading/models/parameter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/models/tank_reading.dart';
import 'border_bar.dart';

class TankEntryGraph extends StatelessWidget {
  const TankEntryGraph({super.key, required this.tankReading});

  final TankReading tankReading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(16),
        ...tankReading.parameters.map((e) => _BottomBar(parameter: e)),
        BorderBar(),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.parameter});

  final Parameter parameter;

  @override
  Widget build(BuildContext context) {
    double height = (parameter.value ?? 0) /
        (parameter.max ?? 0) *
        (MediaQuery.of(context).size.width - 120);
    if (height == 0) {
      height = 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BorderBar(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(minWidth: 40),
                child: Text(
                  parameter.shortName ?? "",
                  style: kDateTimeTextStyle.copyWith(
                    fontSize: 11,
                  ),
                ),
              ),
              Container(
                height: 15,
                width: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    isDarkMode(context) ? Colors.black : Colors.white,
                    kSecondaryColor
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(3),
                  ),
                ),
              ),
              Gap(5),
              Text(
                parameter.value.toString(),
                style: kDateTimeTextStyle.copyWith(
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
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
