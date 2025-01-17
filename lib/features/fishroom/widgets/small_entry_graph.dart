import 'package:fishroom/core/models/tank_reading.dart';
import 'package:flutter/material.dart';

import 'tank_entry_graph.dart';

class SmallEntryGraph extends StatelessWidget {
  const SmallEntryGraph({super.key, required this.tankReading});

  final TankReading tankReading;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          child: TankEntryGraph(tankReading: tankReading),
        ),
      ],
    );
  }
}
