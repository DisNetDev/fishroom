import 'package:fishroom/core/models/tank_reading.dart';
import 'package:fishroom/features/fishroom/widgets/bar_segment.dart';
import 'package:flutter/material.dart';

import '../../tank_reading/models/parameter.dart';

class SmallEntryGraph extends StatelessWidget {
  const SmallEntryGraph({super.key, required this.tankReading});

  final TankReading tankReading;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...List.generate(tankReading.parameters.length, (index) {
          Parameter param = tankReading.parameters[index];

          return BarSegment(
            color: Colors.red,
            tag: param.shortName,
            value: param.value,
            height: _getValue(value: param.value ?? 0, parameter: param),
          );
        })
      ],
    );
  }
}

double _getValue({required double value, required Parameter parameter}) {
  if (value == 0) {
    return 1;
  }

  if (parameter.max != null) {
    return (value / parameter.max!) * 70;
  }

  return value;
}
