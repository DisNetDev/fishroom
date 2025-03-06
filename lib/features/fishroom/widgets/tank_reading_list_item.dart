import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../../core/widgets/date_time_text.dart';
import '../../tank_reading/models/dosage.dart';
import 'small_entry_graph.dart';
import 'tank_entry_graph.dart';

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
          decoration: BoxDecoration(
              border: const GradientBoxBorder(
                  width: 0.5, gradient: kErrorGradient)),
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
        child: OpenContainer(
            closedColor: Colors.transparent,
            openColor: isDarkMode(context) ? Colors.black : Colors.white,
            closedElevation: 0,
            openElevation: 0,
            middleColor: Colors.transparent,
            openBuilder: (context, action) =>
                _OpenedReading(reading: widget.reading),
            closedBuilder: (context, action) =>
                ClosedReading(reading: widget.reading)),
      ),
    );
  }
}

class ClosedReading extends StatefulWidget {
  const ClosedReading({super.key, required this.reading});

  final TankReading reading;

  @override
  State<ClosedReading> createState() => _ClosedReadingState();
}

class _ClosedReadingState extends State<ClosedReading> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: const Color.fromARGB(74, 158, 158, 158)))),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.reading.type.label,
                      style: kHeading1TextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(5),
                    if (widget.reading.dosages.isNotEmpty)
                      for (Dosage dosages in widget.reading.dosages)
                        Text(
                          "${dosages.fertilizer.name} - ${dosages.amount}${dosages.fertilizer.dosageUnit}",
                          style: kHeading2TextStyle,
                        ),
                    if (widget.reading.waterChangePercentage != null)
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
                  ],
                ),
              ),
              if (widget.reading.imageUrl != null)
                GestureDetector(
                  onTap: () => setState(() => open = !open),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
              // if (open && widget.reading.imageUrl != null)
              //   Container(
              //     alignment: Alignment.center,
              //     height: 50,
              //     child: GestureDetector(
              //       onTap: () => showToast(context,
              //           title: "Nope not yet :)",
              //           toastType: ToastType.error),
              //       child: const Text(
              //         "Download",
              //         style: kHeading2TextStyle,
              //       ),
              //     ),
              //   ),
              if (open && widget.reading.imageUrl != null)
                CachedNetworkImage(
                    placeholder: (context, url) => const AspectRatio(
                        aspectRatio: 16 / 9, child: SizedBox(child: Loader())),
                    imageUrl: widget.reading.imageUrl!)
            ],
          ),
        ),
        Positioned(
            top: 10,
            right: 20,
            child: DateTimeText(dateTime: widget.reading.createdAt)),
      ],
    );
  }
}

class _OpenedReading extends StatefulWidget {
  const _OpenedReading({required this.reading});

  final TankReading reading;

  @override
  State<_OpenedReading> createState() => _OpenedReadingState();
}

class _OpenedReadingState extends State<_OpenedReading> {
  double _startDragX = 0;
  static const int _dragDistanceToGoBack =
      60; // How far the user has to drag to go back in pixels

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Since the back gesture doesnt work on this widget, we need to detect the drag and close it
      onHorizontalDragStart: (details) {
        _startDragX = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (details) {
        double dragDistance = details.globalPosition.dx - _startDragX;
        if (dragDistance.abs() > _dragDistanceToGoBack) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: isDarkMode(context) ? Colors.black : Colors.white,
        appBar: RootSliverAppBar(
          title: widget.reading.type.label,
        ),
        body: Stack(
          children: [
            const CustomBackground(),
            Column(
              children: [
                if (widget.reading.imageUrl != null)
                  CachedNetworkImage(
                    placeholder: (context, url) => const AspectRatio(
                        aspectRatio: 16 / 9, child: SizedBox(child: Loader())),
                    imageUrl: widget.reading.imageUrl!,
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.reading.note != null)
                        const Text(
                          "Note",
                          style: kHeading1TextStyle,
                        ),
                      if (widget.reading.note != null)
                        Text(
                          widget.reading.note ?? "",
                          style: kPlainTextStyle,
                        ),
                      const Gap(20),
                      if (widget.reading.type == TankReadingType.measurement)
                        const Text(
                          "Reading",
                          style: kHeading1TextStyle,
                        ),
                      if (widget.reading.type == TankReadingType.measurement)
                        TankEntryGraph(tankReading: widget.reading),
                      if (widget.reading.type == TankReadingType.fertilize)
                        if (widget.reading.dosages.isNotEmpty)
                          for (Dosage dosages in widget.reading.dosages)
                            Text(
                              "${dosages.fertilizer.name} - ${dosages.amount}${dosages.fertilizer.dosageUnit}",
                              style: kHeading2TextStyle,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
