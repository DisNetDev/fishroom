import 'package:flutter/material.dart';

import '../../../core/models/tank.dart';
import '../../../core/widgets/material_container.dart';

class TankTile extends StatelessWidget {
  const TankTile({super.key, required this.tank});
  final Tank tank;

  @override
  Widget build(BuildContext context) {
    double borderRadius = 25;

    String tankTypeNonNullable = tank.type ?? "Tank Type";
    if (tankTypeNonNullable == "") {
      tankTypeNonNullable = "Tank Type";
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: MaterialContainer(
            onTap: () {},
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.black54, blurRadius: 5, offset: Offset(2, 2)),
              ],
              image: DecorationImage(
                image: AssetImage(tank.image?.path ?? ""),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
          padding: const EdgeInsets.only(right: 20, bottom: 10, top: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.transparent, Colors.black],
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(borderRadius),
              bottomLeft: Radius.circular(borderRadius),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tank.name ?? "Tank Name",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$tankTypeNonNullable - ${tank.size}${tank.measurementUnit}",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
