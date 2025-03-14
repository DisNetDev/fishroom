import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/achievements/views/achievements.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/create_tank_flow/create_tank_tank_name.dart';
import 'package:fishroom/features/fishroom/usecases/get_reading_streak.dart';
import 'package:fishroom/features/fishroom/widgets/counter_widget.dart';
import 'package:fishroom/features/tank_inhabitants/views/tank_inhabitants.dart';
import 'package:fishroom/features/tank_reading/views/select_reading_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
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
  bool initialLoad = true;

  AppCubit get appCubit => context.read<AppCubit>();
  TanksCubit get tanksCubit => context.read<TanksCubit>();

  late Tank _tank;

  Future<void> getTankReadings() async {
    if (!tanksCubit.state.readings
        .any((reading) => reading.tankId == _tank.id)) {
      setState(() => loading = true);
      await tanksCubit.getReadingsForTank(_tank);
      setState(() => loading = false);
      Future.delayed(200.ms, () {});
    }
    setState(() => initialLoad = false);
  }

  @override
  void initState() {
    _tank = widget.tank;
    getTankReadings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      edgeOffset: 20,
      onRefresh: () async {
        await tanksCubit
            .getReadingsForTank(_tank)
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
                navPush(
                  context,
                  SelectReadingType(
                    tank: _tank,
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            body: CustomScrollView(
              slivers: [
                RootSliverAppBar(
                  title: _tank.name ?? "Tank Details",
                  sliver: true,
                  actions: [
                    IconButton(
                      onPressed: () {
                        navPush(context, CreateTankTankName(tank: _tank));
                      },
                      icon: const Icon(
                        Icons.edit,
                      ),
                    )
                  ],
                ),
                BlocConsumer<TanksCubit, TanksState>(
                  listener: (context, state) {
                    setState(() {
                      _tank =
                          state.tanks.firstWhere((tank) => tank.id == _tank.id);
                    });
                  },
                  builder: (context, state) {
                    List<TankReading> readings = state.readings
                        .where((reading) => reading.tankId == _tank.id)
                        .toList();

                    return SliverList(
                      delegate: SliverChildListDelegate([
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CounterWidget(
                                heading: "Current Streak",
                                counter: countDailyStreak(
                                    widget.tank, tanksCubit.state.readings),
                              ),
                            ),
                            Expanded(
                              child: CounterWidget(
                                  heading: "Inhabitants",
                                  onTap: () => navPush(context,
                                      TankInhabitants(tank: widget.tank)),
                                  counter: widget.tank.inhabitants.fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue +
                                          (element.count ?? 0))),
                            ),
                            Expanded(
                              child: CounterWidget(
                                heading: "Achievements",
                                counter: widget.tank.achievementIds.length,
                                onTap: () =>
                                    navPush(context, Achievements(tank: _tank)),
                              ),
                            )
                          ],
                        ),
                        if (appCubit.state.settings.parameters.isNotEmpty)
                          Animate(
                              effects: [
                                FadeEffect(
                                  curve: Curves.ease,
                                  delay: 100.ms,
                                )
                              ],
                              child: LineGraphMain(
                                  data: readings.reversed.toList())),
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
                                        tankId: _tank.id,
                                        createdAt: DateTime.now().toString(),
                                        note: "Some Dummy Info"))),
                        ...List.generate(
                          readings.length,
                          (index) => Animate(
                            effects: [
                              FadeEffect(
                                  curve: Curves.ease,
                                  delay: Duration(
                                      milliseconds:
                                          initialLoad ? (100 * index) : 100)),
                            ],
                            child: TankReadingListItem(
                              onDismissed: () {
                                try {
                                  final readingToRemove = readings[index];
                                  readings.removeAt(index);
                                  tanksCubit.deleteTankReading(readingToRemove);
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
                        ),
                        const Gap(300),
                      ]),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
