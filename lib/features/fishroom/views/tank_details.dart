import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/root_appbar.dart';
import 'package:fishroom/features/fishroom/widgets/tank_chart.dart';
import 'package:fishroom/features/tank_reading/create_tank_reading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../cubit/tanks_cubit.dart';
import '../widgets/tank_entry_list_item.dart';

class TankDetails extends StatefulWidget {
  const TankDetails({super.key, required this.tank});

  final Tank tank;

  @override
  State<TankDetails> createState() => _TankDetailsState();
}

class _TankDetailsState extends State<TankDetails> {
  bool loading = false;

  Future<void> getTankReadings() async {
    if (!context
        .read<TanksCubit>()
        .state
        .readings
        .any((reading) => reading.tankId == widget.tank.id)) {
      setState(() => loading = true);
      await context.read<TanksCubit>().getReadingsForTank(widget.tank);
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getTankReadings();
  }

  // Function to show a confirmation dialog for deleting a tank
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this tank?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                try {
                  context.read<TanksCubit>().deleteTank(widget.tank);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } catch (e) {
                  showToast(context,
                      title: "Something went wrong.",
                      toastType: ToastType.error,
                      description: e.toString());
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TanksCubit, TanksState>(
      builder: (context, state) {
        List<TankReading> readings = context
            .read<TanksCubit>()
            .state
            .readings
            .where((reading) => reading.tankId == widget.tank.id)
            .toList();

        return RefreshIndicator(
          edgeOffset: 20,
          onRefresh: () async {
            await context.read<TanksCubit>().getReadingsForTank(widget.tank);
          },
          child: Stack(
            children: [
              const CustomBackground(),
              Scaffold(
                backgroundColor: Colors.transparent,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateTankReading(
                                  tank: widget.tank,
                                )));
                  },
                  child: const Icon(Icons.add),
                ),
                appBar: RootSliverAppBar(
                  title: widget.tank.name ?? "Tank Details",
                  actions: [
                    IconButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                body: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          const TankHistoryChart(),
                          if (loading)
                            for (var i = 0; i < 4; i++)
                              Skeletonizer(
                                  effect: isDarkMode(context)
                                      ? kDarkModeShimmer
                                      : kLightModeShimmer,
                                  child: TankEntryListItem(
                                      onDismissed: () {},
                                      reading: TankReading(
                                          id: "aaa",
                                          ownerId: "bleh",
                                          type: TankReadingType.measurement,
                                          tankId: widget.tank.id,
                                          createdAt: DateTime.now().toString(),
                                          note: "Some Dummy Info"))),
                          ...List.generate(
                            readings.length,
                            (index) {
                              return Skeletonizer(
                                enabled: loading,
                                child: TankEntryListItem(
                                  onDismissed: () {
                                    try {
                                      final readingToRemove = readings[index];
                                      readings
                                          .removeAt(index); // Remove by index
                                      context
                                          .read<TanksCubit>()
                                          .deleteTankReading(readingToRemove);
                                    } on Exception catch (e) {
                                      if (context.mounted) {
                                        showToast(context,
                                            title: "Something went wrong.",
                                            toastType: ToastType.error,
                                            description: e.toString());
                                      }
                                    }
                                  },
                                  reading: readings[index],
                                ),
                              );
                            },
                          ),
                          const Gap(300),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
