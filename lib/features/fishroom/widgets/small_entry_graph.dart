import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/models/tank_reading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../tank_reading/models/parameter.dart';
import 'tank_entry_graph.dart';

class SmallEntryGraph extends StatelessWidget {
  const SmallEntryGraph({super.key, required this.tankReading});

  final TankReading tankReading;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(tankReading.parameters.length, (index) {
            Parameter parameter = tankReading.parameters[index];

            return Text(
              "${parameter.shortName ?? ""}:",
              style: kHeading2TextStyle.copyWith(fontWeight: FontWeight.bold),
            );
          }),
        ),
        Gap(20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(tankReading.parameters.length, (index) {
            Parameter parameter = tankReading.parameters[index];

            return Text(
              parameter.value != null &&
                      parameter.value!.toString().endsWith('.0')
                  ? "${parameter.value!.toInt()} ${parameter.unit ?? ""}"
                  : "${parameter.value ?? ""} ${parameter.unit ?? ""}",
              style: kPlainTextStyle,
            );
          }),
        ),
        // AspectRatio(
        //   aspectRatio: 2,
        //   child: TankEntryGraph(data: tankReading),
        // ),
      ],
    );
  }
}
