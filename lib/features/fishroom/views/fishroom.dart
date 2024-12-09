// ignore_for_file: use_build_context_synchronously

import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/root_navbar.dart';
import 'package:fishroom/features/create_tank_flow/create_tank_tank_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/usecases/can_add_tank.dart';
import '../../../core/widgets/root_sliver_app_bar.dart';
import '../../../core/widgets/root_drawer.dart';
import '../../app/cubit/app_cubit.dart';
import '../cubit/tanks_cubit.dart';
import '../widgets/tank_tile.dart';
import '../widgets/tank_tile_compact.dart';

class Fishroom extends StatefulWidget {
  const Fishroom({super.key});

  @override
  State<Fishroom> createState() => _FishroomState();
}

class _FishroomState extends State<Fishroom> {
  bool loading = false;

  init() async {
    setState(() => loading = true);
    try {
      await context.read<TanksCubit>().getTanks();
    } on Exception catch (e) {
      showToast(
        context,
        title: "Something went wrong.",
        description: e.toString(),
        toastType: ToastType.error,
      );
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        context.watch<AppCubit>().state;
        final TanksState tanksState = context.watch<TanksCubit>().state;

        // Sort tanks by createdAt date, oldest first
        final sortedTanks = List<Tank>.from(tanksState.tanks)
          ..sort((a, b) => (a.createdAt ?? '').compareTo(b.createdAt ?? ''));

        return Stack(
          children: [
            const CustomBackground(),
            Scaffold(
              extendBody: true,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: RootNavbar(currentIndex: 0),
              backgroundColor: Colors.transparent,
              floatingActionButton: canAddTank(context)
                  ? FloatingActionButton(
                      shape: CircleBorder(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CreateTankTankName()));
                      },
                      child: const Icon(Icons.add),
                    )
                  : null,
              appBar: tanksState.tanks.isEmpty || loading
                  ? const RootSliverAppBar(
                      implyLeading: false,
                      title: "Fishroom",
                    )
                  : null,
              endDrawer: const RootDrawer(),
              body: Builder(
                builder: (context) {
                  if (loading) {
                    return Column(
                      children: [
                        Skeletonizer(
                            effect: isDarkMode(context)
                                ? kDarkModeShimmer
                                : kLightModeShimmer,
                            child: context
                                    .read<AppCubit>()
                                    .state
                                    .settings
                                    .compactTankTile
                                ? TankTileCompact(
                                    tank: Tank(id: const Uuid().v4()))
                                : TankTile(tank: Tank(id: const Uuid().v4())))
                      ],
                    );
                  }
                  if (sortedTanks.isNotEmpty) {
                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        const RootSliverAppBar(
                          title: "Fishroom",
                          sliver: true,
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (index == sortedTanks.length) {
                                return const Gap(
                                    200); //return a gap at the bottom of the screen
                              } else {
                                return context
                                        .read<AppCubit>()
                                        .state
                                        .settings
                                        .compactTankTile
                                    ? TankTileCompact(tank: sortedTanks[index])
                                    : TankTile(tank: sortedTanks[index]);
                              }
                            },
                            childCount: sortedTanks.length + 1,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return InkWell(
                      radius: 50,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CreateTankTankName()));
                      },
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Tanks Added",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic)),
                          Text("Tap to add a Tank and get started!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic)),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
