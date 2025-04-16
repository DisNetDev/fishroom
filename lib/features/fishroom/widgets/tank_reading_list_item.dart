import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/models/tank_reading.dart';
import '../../../core/widgets/date_time_text.dart';
import '../../tank_reading/models/dosage.dart';
import 'small_entry_graph.dart';

class TankReadingListItem extends StatefulWidget {
  const TankReadingListItem(
      {super.key, required this.reading, required this.onDismissed});

  final TankReading reading;
  final void Function() onDismissed;

  @override
  State<TankReadingListItem> createState() => _TankReadingListItemState();
}

class _TankReadingListItemState extends State<TankReadingListItem> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Skeleton.shade(
      child: Dismissible(
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete this entry?\nThis cannot be undone.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                ) ??
                false;
          },
          direction: DismissDirection.endToStart,
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Delete",
                  style: kHeading1TextStyle.copyWith(
                      color: Colors.deepOrange, fontWeight: FontWeight.w500),
                ),
                const Gap(20),
                const Icon(Icons.delete, color: Colors.deepOrange),
              ],
            ),
          ),
          key: Key(widget.reading.id),
          onDismissed: (direction) {
            widget.onDismissed();
          },
          child: ReadingWidget(reading: widget.reading)),
    );
  }
}

class ReadingWidget extends StatefulWidget {
  const ReadingWidget({super.key, required this.reading});

  final TankReading reading;

  @override
  State<ReadingWidget> createState() => _ReadingWidgetState();
}

class _ReadingWidgetState extends State<ReadingWidget> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDarkMode(context)
                ? Colors.white.withAlpha(10)
                : Colors.black.withAlpha(10)),
        margin: const EdgeInsets.only(bottom: 10),
        child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: open
                    ? [Colors.white, Colors.white]
                    : [
                        Colors.white,
                        Colors.transparent,
                      ],
                stops: [0.5, 1],
              ).createShader(rect);
            },
            child: AnimatedSize(
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
              child: Container(
                alignment: Alignment.topCenter,
                height: open ? null : 70,
                child: InkWell(
                  splashColor:
                      const Color.fromARGB(255, 0, 82, 105).withAlpha(128),
                  radius: 50,
                  onTap: () => setState(() => open = !open),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15, top: 10, right: 10, bottom: 0),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    getIconForType(widget.reading.type),
                                    Gap(10),
                                    Text(
                                      widget.reading.type.label,
                                      style: kHeading1TextStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const Gap(5),
                                if (widget.reading.dosages.isNotEmpty)
                                  for (Dosage dosages in widget.reading.dosages)
                                    Text(
                                      "${dosages.fertilizer.name} - ${dosages.amount}${dosages.fertilizer.dosageUnit}",
                                      style: kHeading2TextStyle,
                                    ),
                                if (widget.reading.waterChangePercentage !=
                                    null)
                                  Text(
                                    "${widget.reading.waterChangePercentage.toString()}%",
                                    style: kHeading2TextStyle,
                                  ),
                                if (widget.reading.note != "" &&
                                    widget.reading.note != null)
                                  Text(
                                    widget.reading.note!,
                                    style: kPlainTextStyle,
                                  ),
                                if (widget.reading.parameters.isNotEmpty)
                                  SmallEntryGraph(tankReading: widget.reading),
                                if (widget.reading.imageUrl != null)
                                  const Gap(20),
                                if (widget.reading.imageUrl != null)
                                  Image.network(
                                    widget.reading.imageUrl!,
                                  ),
                              ],
                            ),
                            const Gap(15),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 20,
                        child: DateTimeText(dateTime: widget.reading.createdAt),
                      ),
                      Positioned(
                          bottom: 2,
                          right: 5,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 10),
                            child: open
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

Icon getIconForType(TankReadingType type) {
  switch (type) {
    case TankReadingType.measurement:
      return const Icon(Symbols.trending_up_rounded);
    case TankReadingType.fertilize:
      return const Icon(Symbols.eco);
    case TankReadingType.waterChange:
      return const Icon(Symbols.colors);
    case TankReadingType.note:
      return const Icon(Symbols.comment);
    case TankReadingType.trim:
      return const Icon(Symbols.content_cut_rounded);

    default:
      return const Icon(Symbols.keyboard_arrow_right_rounded);
  }
}
