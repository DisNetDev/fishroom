import 'package:collection/collection.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/achievements/views/achievements.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/create_tank_flow/create_tank_tank_name.dart';
import 'package:fishroom/features/fishroom/usecases/check_for_achievements.dart';
import 'package:fishroom/features/fishroom/widgets/counter_widget.dart';
import 'package:fishroom/features/fishroom/widgets/tank_details_overview.dart';
import 'package:fishroom/features/tank_inhabitants/views/tank_inhabitants.dart';
import 'package:fishroom/features/tank_reading/views/select_reading_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../create_tank_flow/create_tank_targets.dart';
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
  bool streakLoading = false;
  bool filterOpen = false;
  List<String> filters = [];
  AppCubit get appCubit => context.read<AppCubit>();
  TanksCubit get tanksCubit => context.read<TanksCubit>();

  late Tank? _tank;

  Future<void> getTankReadings({bool showLoading = true}) async {
    try {
      if (showLoading) {
        setState(() => loading = true);
      }
      if (_tank != null) {
        await tanksCubit.getReadingsForTank(_tank!);
      }
      setState(() => loading = false);
      setState(() => initialLoad = false);
    } catch (e) {
      setState(() => initialLoad = false);
    }
  }

  @override
  void initState() {
    _tank = tanksCubit.state.tanks
        .firstWhereOrNull((tank) => tank.id == widget.tank.id);
    getTankReadings();
    getTankStreakAndCheckForAchievements();
    super.initState();
  }

  Future<void> getTankStreakAndCheckForAchievements() async {
    if (_tank != null) {
      setState(() => streakLoading = true);
      await Future.wait([
        tanksCubit.updateTankStreak(context, _tank!.id),
        Future.delayed(1000.ms, () {}),
      ]);
      setState(() => streakLoading = false);
      checkForAchievement(context, _tank!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      edgeOffset: 20,
      onRefresh: () async {
        if (_tank != null) {
          try {
            await tanksCubit.getReadingsForTank(_tank!);
            setState(() => loading = false);
            getTankStreakAndCheckForAchievements();
          } catch (e) {
            showToast(context,
                title: "Something went wrong getting readings.",
                description: e.toString(),
                toastType: ToastType.error);
          } finally {
            setState(() => loading = false);
          }
        }
      },
      child: Stack(
        children: [
          const CustomBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {
                if (_tank != null) {
                  navPush(
                    context,
                    SelectReadingType(
                      tank: _tank!,
                    ),
                  ).then((value) => getTankStreakAndCheckForAchievements());
                }
              },
              child: const Icon(Icons.add),
            ),
            body: CustomScrollView(
              clipBehavior: Clip.none,
              slivers: [
                RootSliverAppBar(
                  title: "",
                  sliver: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          if (_tank != null) {
                            navPush(context, CreateTankTargets(tank: _tank!));
                          }
                        },
                        icon: Icon(Symbols.bar_chart)),
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
                BlocBuilder<TanksCubit, TanksState>(
                  builder: (context, state) {
                    List<TankReading> readings = state.readings
                        .where((reading) => reading.tankId == _tank?.id)
                        .toList();

                    Tank? currentTank = state.tanks
                        .firstWhereOrNull((test) => test.id == _tank?.id);

                    List<Widget> widgets = [
                      Animate(effects: [
                        FadeEffect(
                          curve: Curves.ease,
                          delay: 200.ms,
                        )
                      ], child: TankDetailsOverview(tank: _tank!)),
                      Animate(
                        effects: [
                          FadeEffect(
                            curve: Curves.ease,
                            delay: 300.ms,
                          )
                        ],
                        child: Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(1),
                            Expanded(
                              child: CounterWidget(
                                heading: "Current Streak",
                                counter: currentTank?.streak ?? 0,
                                loading: streakLoading,
                              ),
                            ),
                            Expanded(
                              child: CounterWidget(
                                  heading: "Inhabitants",
                                  onTap: () async {
                                    if (_tank != null) {
                                      navPush(context,
                                          TankInhabitants(tank: _tank!));
                                    }
                                  },
                                  counter: currentTank == null
                                      ? 0
                                      : currentTank.inhabitants.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              (element.count ?? 0))),
                            ),
                            Expanded(
                              child: CounterWidget(
                                heading: "Achievements",
                                counter:
                                    currentTank?.achievementIds.length ?? 0,
                                onTap: () {
                                  if (_tank != null) {
                                    navPush(
                                        context, Achievements(tank: _tank!));
                                  }
                                },
                              ),
                            ),
                            Gap(1),
                          ],
                        ),
                      ),
                      Gap(8),
                      if (appCubit.state.settings.parameters.isNotEmpty)
                        Animate(
                            effects: [
                              FadeEffect(
                                curve: Curves.ease,
                                delay: 200.ms,
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
                                      tankId: _tank?.id ?? "",
                                      createdAt: DateTime.now().toString(),
                                      note: "Some Dummy Info"))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Readings",
                              style: kHeadingTextStyle,
                            ),
                          ],
                        ),
                      ),
                      if (filterOpen)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _FilterWidget(
                                name: "Measurement",
                                selected: filters.contains("Measurement"),
                                onTap: () {
                                  setState(
                                    () {
                                      if (filters.contains("Measurement")) {
                                        filters.remove("Measurement");
                                      } else {
                                        filters.add("Measurement");
                                      }
                                    },
                                  );
                                  getTankReadings(showLoading: false);
                                },
                              ),
                              _FilterWidget(
                                name: "Fertilize",
                                selected: filters.contains("Fertilize"),
                                onTap: () {
                                  setState(
                                    () {
                                      if (filters.contains("Fertilize")) {
                                        filters.remove("Fertilize");
                                      } else {
                                        filters.add("Fertilize");
                                      }
                                    },
                                  );
                                  getTankReadings(showLoading: false);
                                },
                              ),
                              _FilterWidget(
                                name: "Feed",
                                selected: filters.contains("Feed"),
                                onTap: () {
                                  setState(
                                    () {
                                      if (filters.contains("Feed")) {
                                        filters.remove("Feed");
                                      } else {
                                        filters.add("Feed");
                                      }
                                    },
                                  );
                                  getTankReadings(showLoading: false);
                                },
                              ),
                              _FilterWidget(
                                name: "Note",
                                selected: filters.contains("Note"),
                                onTap: () {
                                  setState(
                                    () {
                                      if (filters.contains("Note")) {
                                        filters.remove("Note");
                                      } else {
                                        filters.add("Note");
                                      }
                                    },
                                  );
                                  getTankReadings(showLoading: false);
                                },
                              ),
                              _FilterWidget(
                                name: "Water Change",
                                selected: filters.contains("Water Change"),
                                onTap: () {
                                  setState(
                                    () {
                                      if (filters.contains("Water Change")) {
                                        filters.remove("Water Change");
                                      } else {
                                        filters.add("Water Change");
                                      }
                                    },
                                  );
                                  getTankReadings(showLoading: false);
                                },
                              ),
                            ],
                          ),
                        ),
                      Gap(16),
                      ...List.generate(
                        readings.length,
                        (readingsIndex) => TankReadingListItem(
                          onDismissed: () {
                            try {
                              final readingToRemove = readings[readingsIndex];
                              readings.removeAt(readingsIndex);
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
                          reading: readings[readingsIndex],
                        ),
                      ),
                      const Gap(300),
                    ];

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: widgets.length,
                          (context, index) => widgets[index]),
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

class _FilterWidget extends StatelessWidget {
  const _FilterWidget(
      {required this.name, required this.selected, required this.onTap});

  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: kTertiaryColor),
          color: selected ? kTertiaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(name,
            style: kDateTimeTextStyle.copyWith(
                color: !selected ? null : Colors.white)),
      ),
    );
  }
}
