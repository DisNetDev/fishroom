import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/create_tank_flow/create_tank_tank_name.dart';
import 'package:fishroom/features/tank_reading/views/select_reading_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../graphs/widgets/line_graph_main.dart';
import '../../tank_inhabitants/models/inhabitant.dart';
import '../../tank_inhabitants/widgets/add_inhabitants.dart';
import '../../tank_inhabitants/widgets/inhabitant_widget.dart';
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

  AppCubit get appCubit => context.read<AppCubit>();
  TanksCubit get tanksCubit => context.read<TanksCubit>();

  late Tank _tank;

  Future<void> getTankReadings() async {
    if (!tanksCubit.state.readings
        .any((reading) => reading.tankId == _tank.id)) {
      setState(() => loading = true);
      await tanksCubit.getReadingsForTank(_tank);
      setState(() => loading = false);
    }
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
                        ...List.generate(
                          _tank.inhabitants.length,
                          (index) => InhabitantWidget(
                            inhabitant: _tank.inhabitants[index],
                            onAdd: _addInhabitant,
                          ),
                        ),
                        AddInhabitants(
                          tank: _tank,
                          chosenInhabitant: _addInhabitant,
                        ),
                        if (appCubit.state.settings.parameters.isNotEmpty)
                          LineGraphMain(data: readings.reversed.toList()),
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
                          (index) => TankReadingListItem(
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

  void _addInhabitant(Inhabitant inhabitant) {
    Tank tank = _tank.copyWith(
      inhabitants: [
        inhabitant,
        ..._tank.inhabitants.where(
            (existingInhabitant) => existingInhabitant.id != inhabitant.id),
      ],
    );
    tank.inhabitants.removeWhere((inhabitant) => inhabitant.count == 0);

    try {
      tanksCubit.updateTank(tank, null);
    } catch (e) {
      showToast(context,
          title: "Error adding inhabitant...",
          description: e.toString(),
          toastType: ToastType.error);
    }
  }
}
