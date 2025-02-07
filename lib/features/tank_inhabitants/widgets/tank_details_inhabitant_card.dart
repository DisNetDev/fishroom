import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../core/models/tank.dart';
import '../models/inhabitant.dart';

class TankDetailsInhabitantCard extends StatelessWidget {
  const TankDetailsInhabitantCard({
    super.key,
    required this.tank,
    required this.onAddInhabitant,
  });

  final Tank tank;
  final Function(Inhabitant) onAddInhabitant;

  @override
  Widget build(BuildContext context) {
    int totalInhabitants = tank.inhabitants
        .map((inhabitant) => inhabitant.count ?? 0)
        .fold(0, (a, b) => a + b);

    return Container(
      decoration: BoxDecoration(),
      child: Column(
        children: [
          SvgPicture.asset(
            "assets/icons/fish.svg",
            height: 20,
            colorFilter: ColorFilter.mode(
              isDarkMode(context) ? Colors.white : Colors.black,
              BlendMode.srcIn,
            ),
          ),
          Gap(8),
          Text("x $totalInhabitants"),
        ],
      ),
    );
  }
}
