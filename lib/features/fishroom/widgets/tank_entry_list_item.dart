import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../../core/widgets/date_time_text.dart';
import 'small_entry_graph.dart';

class TankEntryListItem extends StatelessWidget {
  const TankEntryListItem(
      {super.key, required this.reading, required this.onDismissed});

  final TankReading reading;
  final void Function() onDismissed;

  @override
  Widget build(BuildContext context) {
    return Skeleton.shade(
      child: Dismissible(
        background: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.delete),
              Icon(Icons.delete),
            ],
          ),
        ),
        key: Key(reading.id),
        onDismissed: (direction) {
          onDismissed();
        },
        child: Skeleton.shade(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            height: reading.type == TankReadingType.measurement ? 120 : 80,
            decoration: BoxDecoration(
              border: const GradientBoxBorder(
                  width: 0.3, gradient: kPrimaryGradient),
              borderRadius: BorderRadius.circular(10),
              color: isDarkMode(context)
                  ? Colors.black87
                  : const Color.fromARGB(55, 255, 255, 255),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reading.type.label,
                        style: kHeading1TextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        reading.note ?? "",
                        style: kPlainTextStyle,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DateTimeText(dateTime: reading.createdAt),
                    const Expanded(child: SizedBox()),
                    reading.type == TankReadingType.note
                        ? const SizedBox()
                        : SmallEntryGraph(tankReading: reading),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
