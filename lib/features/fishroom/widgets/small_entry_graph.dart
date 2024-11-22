import 'package:fishroom/core/models/tank_reading.dart';
import 'package:flutter/material.dart';

import '../../tank_reading/models/parameter.dart';
import 'bar_segment.dart';

class SmallEntryGraph extends StatelessWidget {
  const SmallEntryGraph({super.key, required this.tankReading});

  final TankReading tankReading;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (tankReading.ph != null)
          BarSegment(
            color: Colors.red,
            tag: "PH",
            value: tankReading.ph,
            height: _getValue(
                value: tankReading.ph!,
                parameter: readingParameters
                    .firstWhere((para) => para.shortName == "PH")),
          ),
        if (tankReading.ta != null)
          BarSegment(
            color: Colors.green,
            tag: "TA",
            value: tankReading.ta,
            height: _getValue(
                value: tankReading.ta!,
                parameter: readingParameters
                    .firstWhere((para) => para.shortName == "TA")),
          ),
        if (tankReading.no2 != null)
          BarSegment(
            color: Colors.yellow,
            tag: "NO2",
            value: tankReading.no2,
            height: _getValue(
                value: tankReading.no2!,
                parameter: readingParameters
                    .firstWhere((para) => para.shortName == "NO2")),
          ),
        if (tankReading.no3 != null)
          BarSegment(
            color: Colors.purple,
            tag: "NO3",
            value: tankReading.no3,
            height: _getValue(
                value: tankReading.no3!,
                parameter: readingParameters
                    .firstWhere((para) => para.shortName == "NO3")),
          ),
        if (tankReading.gh != null)
          BarSegment(
            color: Colors.blue,
            tag: "GH",
            value: tankReading.gh,
            height: _getValue(
                value: tankReading.gh!,
                parameter: readingParameters
                    .firstWhere((para) => para.shortName == "GH")),
          ),
        if (tankReading.kh != null)
          BarSegment(
            color: Colors.amber,
            tag: "KH",
            value: tankReading.kh,
            height: _getValue(
                value: tankReading.kh!,
                parameter: readingParameters
                    .firstWhere((para) => para.shortName == "KH")),
          ),
        if (tankReading.tds != null)
          BarSegment(
            color: Colors.brown,
            tag: "TDS",
            value: tankReading.tds,
            height: _getValue(
                value: tankReading.tds!,
                parameter: readingParameters
                    .firstWhere((para) => para.shortName == "TDS")),
          ),
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
