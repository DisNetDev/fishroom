import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';

import '../../../core/models/tank_reading.dart';
import '../../../core/widgets/date_time_text.dart';
import '../../../core/widgets/material_container.dart';
import 'small_entry_graph.dart';

class TankEntryListItem extends StatelessWidget {
  const TankEntryListItem({super.key, required this.reading});

  final TankReading reading;

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return MaterialContainer(
      elevation: 5,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(10, 0, 0, 0)),
        borderRadius: BorderRadius.circular(10),
        color: isDarkTheme ? Colors.black87 : Colors.white,
      ),
      height: 100,
      child: Stack(
        children: [
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
              : const Positioned(bottom: 0, right: 0, child: SmallEntryGraph()),
          Positioned(
            top: 0,
            right: 0,
            child: DateTimeText(dateTime: reading.dateTime),
          ),
        ],
      ),
    );
  }
}
