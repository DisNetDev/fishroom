import 'package:collection/collection.dart';
import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/achievements/views/congrats.dart';
import 'package:fishroom/features/fishroom/cubit/tanks_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../core/models/tank.dart';
import '../../../core/usecases/show_toast.dart';
import '../models/achievement.dart';
import '../widgets/achievement_card.dart';

class Achievements extends StatefulWidget {
  const Achievements({super.key, required this.tank});

  final Tank tank;

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  Tank get _tank =>
      tanksCubit.state.tanks
          .firstWhereOrNull((test) => test.id == widget.tank.id) ??
      widget.tank;
  TanksCubit get tanksCubit => context.read<TanksCubit>();

  bool loading = false;
  List<Achievement> achievements = [];

  init() async {
    try {
      setState(() => loading = true);
      achievements = await tanksCubit.getAvailableAchievements();
      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
      showToast(context,
          title: "Error Loading Achievements",
          toastType: ToastType.error,
          description: e.toString());
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBackground(),
        Scaffold(
          appBar: RootSliverAppBar(
            title: "Achievements",
            implyLeading: true,
          ),
          body: loading
              ? Center(
                  child: Loader(),
                )
              : SingleChildScrollView(
                  child: BlocBuilder<TanksCubit, TanksState>(
                    builder: (context, state) {
                      return Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Gap(20),
                          ...List.generate(
                              achievements.length,
                              (index) => AchievementCard(
                                  achievement: achievements[index],
                                  enabled: _tank.achievementIds.any((test) =>
                                      test == achievements[index].id))),
                          Gap(20),
                        ],
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
