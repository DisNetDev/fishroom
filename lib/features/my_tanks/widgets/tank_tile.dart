import 'package:flutter/material.dart';

import '../../../core/models/tank.dart';
import '../../../core/widgets/material_container.dart';

class TankTile extends StatelessWidget {
  const TankTile({super.key, required this.tank});
  final Tank tank;

  @override
  Widget build(BuildContext context) {
    String tankTypeNonNullable = tank.type ?? "Tank Type";
    if (tankTypeNonNullable == "") {
      tankTypeNonNullable = "Tank Type";
    }
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: MaterialContainer(
        padding: const EdgeInsets.all(20),
        onTap: () {},
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(tank.image?.path ?? ""),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              tank.name ?? "Tank Name",
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$tankTypeNonNullable - ${tank.size}${tank.measurementUnit}",
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}
