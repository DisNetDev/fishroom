import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:fishroom/features/tank_reading/models/parameter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';
import '../cubit/tanks_cubit.dart';
import 'border_bar.dart';

class TankEntryGraph extends StatelessWidget {
  const TankEntryGraph({super.key, required this.tankReading});

  final TankReading tankReading;

  @override
  Widget build(BuildContext context) {
    final tank = context
        .read<TanksCubit>()
        .state
        .tanks
        .firstWhere((element) => element.id == tankReading.tankId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(16),
        ...tankReading.parameters.map((e) => _BottomBar(
            parameter: e,
            target: tank.targets
                .firstWhereOrNull((element) => element.paramID == e.id))),
        BorderBar(),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.parameter, this.target});

  final Parameter parameter;
  final Target? target;

  @override
  Widget build(BuildContext context) {
    double width = (parameter.value ?? 0) /
        (parameter.max ?? 0) *
        (MediaQuery.of(context).size.width - 200);
    if (width == 0) {
      width = 1;
    }

    LinearGradient gradient = LinearGradient(colors: [
      isDarkMode(context) ? Colors.transparent : Colors.grey.shade100,
      isDarkMode(context) ? kSecondaryColor : kPrimaryColor.withAlpha(120)
    ], begin: Alignment.centerLeft, end: Alignment.centerRight);

    Gradient generateGradient(Target target, Parameter parameter) {
      Color firstColor =
          isDarkMode(context) ? Colors.transparent : Colors.grey.shade100;
      Color secondColor = isDarkMode(context) ? kPrimaryColor : kSecondaryColor;

      // Calculate the difference between target and parameter values
      double difference = (target.value - (parameter.value ?? 0)).abs();
      double step = parameter.step ?? 0;

      // Within 1 step (including exact match) -> green
      if (difference <= step) {
        secondColor = Colors.green;
      }
      // Within 2 steps -> orange
      else if (difference <= step * 2) {
        secondColor = Colors.orange;
      }
      // More than 2 steps away -> red
      else {
        secondColor = Colors.red;
      }

      return LinearGradient(
          colors: [firstColor, secondColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight);
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
                width: width,
                decoration: BoxDecoration(
                  gradient: target == null
                      ? gradient
                      : generateGradient(target!, parameter),
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
              Gap(20),
              if (target != null)
                Text(
                  "Target: ${target?.value.toString() ?? ""}",
                  style: kDateTimeTextStyle.copyWith(
                      fontSize: 11, color: Colors.grey),
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
