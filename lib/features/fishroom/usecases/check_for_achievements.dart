import 'package:collection/collection.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/features/achievements/views/congrats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/tank.dart';
import '../../achievements/models/achievement.dart';
import '../cubit/tanks_cubit.dart';

Future<void> checkForAchievement(BuildContext context, String tankId) async {
  List<Achievement> achievementsToAdd = [];
  TanksCubit tanksCubit = context.read<TanksCubit>();

  List<Achievement> availableAchievements =
      await tanksCubit.getAvailableAchievements();

  Tank? tank = tanksCubit.state.tanks.firstWhereOrNull((t) => t.id == tankId);

  if ((tank?.streak ?? 0) >= 7) {
    Achievement? achievement = availableAchievements
        .firstWhereOrNull((e) => e.name.toLowerCase() == "average cycler");
    if (achievement != null) {
      achievementsToAdd.add(achievement);
    }
  }
  if ((tank?.streak ?? 0) >= 30) {
    Achievement? achievement = availableAchievements
        .firstWhereOrNull((e) => e.name.toLowerCase() == "dedicated");
    if (achievement != null) {
      achievementsToAdd.add(achievement);
    }
  }
  if ((tank?.streak ?? 0) >= 365) {
    Achievement? achievement = availableAchievements
        .firstWhereOrNull((e) => e.name.toLowerCase() == "testing machine");
    if (achievement != null) {
      achievementsToAdd.add(achievement);
    }
  }

  if (achievementsToAdd.isNotEmpty) {
    achievementsToAdd
        .removeWhere((e) => (tank?.achievementIds.contains(e.id) ?? false));
  }

  if (achievementsToAdd.isNotEmpty) {
    await tanksCubit.updateTankAchievements(tankId, achievementsToAdd);
    navPush(context, Congrats(achievements: achievementsToAdd));
  }
}
