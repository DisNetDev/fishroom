import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/tank_reading/create_tank_reading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../graphs/widgets/graph_preview.dart';
import '../cubit/tanks_cubit.dart';
import '../widgets/tank_entry_list_item.dart';
import 'edit_tank.dart';

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

  @override
  Widget build(BuildContext context) {
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
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            appBar: RootSliverAppBar(
              title: widget.tank.name ?? "Tank Details",
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTank(tank: widget.tank)));
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                )
              ],
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  BlocBuilder<TanksCubit, TanksState>(
                    builder: (context, state) {
                      List<TankReading> readings = state.readings
                          .where((reading) => reading.tankId == widget.tank.id)
                          .toList();

                      return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          // if (!loading) GraphPreview(),
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
                            (index) => TankEntryListItem(
                              onDismissed: () {
                                try {
                                  final readingToRemove = readings[index];
                                  readings.removeAt(index); // Remove by index
                                  context
                                      .read<TanksCubit>()
                                      .deleteTankReading(readingToRemove);
                                } catch (e) {
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
                          ),
                          const Gap(300),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
