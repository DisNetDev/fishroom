import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/constants.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../../core/usecases/nav_push.dart';
import '../models/achievement.dart';
import '../views/congrats.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard(
      {super.key, required this.achievement, required this.enabled});

  final Achievement achievement;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (kDebugMode) {
          navPush(context, Congrats(achievements: [achievement]));
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: GradientBoxBorder(
                gradient: enabled
                    ? LinearGradient(
                        colors: [
                          kPrimaryColor,
                          kSecondaryColor,
                        ],
                      )
                    : kDisabledGradient),
            color: isDarkMode(context)
                ? Colors.transparent
                : Colors.grey.shade100),
        child: Row(
          children: [
            Icon(
              Symbols.social_leaderboard_rounded,
              color: enabled ? null : Colors.grey,
            ),
            Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.name,
                    style: kHeading1TextStyle.copyWith(
                        color: enabled ? null : Colors.grey),
                  ),
                  Text(
                    achievement.description,
                    style: kPlainTextStyle.copyWith(
                        color: enabled ? null : Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
