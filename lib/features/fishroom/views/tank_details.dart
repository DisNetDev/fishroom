import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/create_tank_flow/create_tank_tank_name.dart';
import 'package:fishroom/features/tank_reading/views/create_tank_reading.dart';
import 'package:fishroom/features/tank_reading/views/select_reading_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../graphs/widgets/graph_preview.dart';
import '../../graphs/widgets/line_graph_main.dart';
import '../cubit/tanks_cubit.dart';
import '../widgets/tank_reading_list_item.dart';

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
        await context
            .read<TanksCubit>()
            .getReadingsForTank(widget.tank)
            .then((value) => setState(() => loading = false));
      },
      child: Stack(
        children: [
          const CustomBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectReadingType(
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
                            builder: (context) =>
                                CreateTankTankName(tank: widget.tank)));
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
                          if (readings.isEmpty && !loading)
                            Center(
                                child:
                                    Text("Add some readings to get started!")),
                          if (context
                                  .read<AppCubit>()
                                  .state
                                  .settings
                                  .parameters
                                  .isNotEmpty &&
                              readings.isNotEmpty)
                            LineGraphMain(data: readings),
                          Gap(20),
                          if (loading)
                            for (var i = 0; i < 4; i++)
                              Skeletonizer(
                                  effect: isDarkMode(context)
                                      ? kDarkModeShimmer
                                      : kLightModeShimmer,
                                  child: TankReadingListItem(
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
                            (index) => TankReadingListItem(
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
