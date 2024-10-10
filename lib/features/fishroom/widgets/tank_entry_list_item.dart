import 'dart:ui';

import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../../core/widgets/date_time_text.dart';
import '../../../core/widgets/material_container.dart';
import 'small_entry_graph.dart';

class TankEntryListItem extends StatelessWidget {
  const TankEntryListItem({super.key, required this.reading});

  final TankReading reading;

  @override
  Widget build(BuildContext context) {
    return Skeleton.shade(
      child: MaterialContainer(
        // elevation: 5,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: isDarkMode(context) ? Colors.black : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
          color: isDarkMode(context)
              ? Colors.black87
              : const Color.fromARGB(55, 255, 255, 255),
        ),
        height: 100,
        child: Stack(
          children: [
            BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reading.type.label,
                  style: kPlainTextStyle,
                ),
                Text(
                  reading.note,
                  style: kPlainTextStyle,
                ),
              ],
            ),
            reading.type == TankReadingType.note
                ? const SizedBox()
                : const Positioned(
                    bottom: 0, right: 0, child: SmallEntryGraph()),
            Positioned(
              top: 0,
              right: 0,
              child: DateTimeText(dateTime: reading.createdAt),
            ),
          ],
        ),
      ),
    );
  }
}
