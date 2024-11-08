import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../../core/widgets/date_time_text.dart';
import 'small_entry_graph.dart';

class TankEntryListItem extends StatefulWidget {
  const TankEntryListItem(
      {super.key, required this.reading, required this.onDismissed});

  final TankReading reading;
  final void Function() onDismissed;

  @override
  State<TankEntryListItem> createState() => _TankEntryListItemState();
}

class _TankEntryListItemState extends State<TankEntryListItem> {
  bool open = false;
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
        key: Key(widget.reading.id),
        onDismissed: (direction) {
          widget.onDismissed();
        },
        child: Skeleton.shade(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                constraints: BoxConstraints(
                  minHeight: widget.reading.type == TankReadingType.measurement
                      ? 120
                      : 80,
                ),
                decoration: BoxDecoration(
                  border: const GradientBoxBorder(
                      width: 0.3, gradient: kPrimaryGradient),
                  borderRadius: BorderRadius.circular(10),
                  color: isDarkMode(context)
                      ? Colors.black87
                      : const Color.fromARGB(55, 255, 255, 255),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.reading.type.label,
                                  style: kHeading1TextStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget.reading.note ?? "",
                                  style: kPlainTextStyle,
                                ),
                              ],
                            ),
                          ),
                          if (widget.reading.type ==
                              TankReadingType.measurement)
                            const Expanded(child: SizedBox())
                        ],
                      ),
                    ),
                    if (widget.reading.imageUrl != null)
                      GestureDetector(
                        onTap: () => setState(() => open = !open),
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: open
                                    ? null
                                    : const BorderRadius.vertical(
                                        bottom: Radius.circular(10)),
                                gradient: const LinearGradient(colors: [
                                  Color.fromARGB(102, 0, 198, 253),
                                  Colors.transparent
                                ])),
                            child: Row(
                              children: [
                                const Icon(
                                  Symbols.attach_file,
                                  size: 16,
                                ),
                                const Text(
                                  "Photo Attached",
                                  style: kDateTimeTextStyle,
                                ),
                                const Gap(20),
                                Icon(
                                  !open
                                      ? Symbols.keyboard_arrow_down
                                      : Symbols.keyboard_arrow_up,
                                  size: 16,
                                ),
                              ],
                            )),
                      ),
                    if (open && widget.reading.imageUrl != null)
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: GestureDetector(
                          onTap: () => showToast(context,
                              title: "Nope not yet :)",
                              toastType: ToastType.error),
                          child: const Text(
                            "Download",
                            style: kHeading2TextStyle,
                          ),
                        ),
                      ),
                    if (open && widget.reading.imageUrl != null)
                      ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(10)),
                          child: CachedNetworkImage(
                              imageUrl: widget.reading.imageUrl!))
                  ],
                ),
              ),
              Positioned(
                  top: 10,
                  right: 20,
                  child: DateTimeText(dateTime: widget.reading.createdAt)),
              Positioned(
                bottom: 8,
                right: 15,
                child: widget.reading.type == TankReadingType.note
                    ? const SizedBox()
                    : SmallEntryGraph(tankReading: widget.reading),
              )
            ],
          ),
        ),
      ),
    );
  }
}
