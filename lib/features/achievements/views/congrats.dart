import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:rive/rive.dart';

import '../models/achievement.dart';
import '../widgets/achievement_card.dart';

class Congrats extends StatefulWidget {
  const Congrats({super.key, required this.achievement});

  final Achievement achievement;

  @override
  State<Congrats> createState() => _CongratsState();
}

class _CongratsState extends State<Congrats> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation('Confetti 1', autoplay: false);
    _playAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    await Future.delayed(Duration(milliseconds: 1500));
    fishLog('Playing animation');
    setState(() => _controller.isActive = true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBackground(),
        SizedBox(
            height: MediaQuery.of(context).size.width * 2,
            width: MediaQuery.of(context).size.width * 2,
            child: RiveAnimation.asset(
              "assets/congrats.riv",
              fit: BoxFit.cover,
              onInit: (_) => setState(() {}),
              controllers: [_controller],
            )),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Congrats',
                    style: kHeadingTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'You have earned a new achievement',
                    style: kHeading1TextStyle,
                    textAlign: TextAlign.center,
                  ),
                  Gap(50),
                  Icon(
                    Symbols.social_leaderboard_rounded,
                    size: MediaQuery.of(context).size.width * 0.2,
                  ),
                  Gap(50),
                  AchievementCard(
                    achievement: widget.achievement,
                    enabled: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
