import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/widgets/material_container.dart';
import '../views/tank_details.dart';

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

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TankDetails(tank: tank)));
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: MaterialContainer(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 5,
                        offset: Offset(2, 2)),
                  ],
                  color: isDarkMode(context) == false
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : Colors.black,
                  border: const GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [kPrimaryColor, kSecondaryColor],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: tank.imageUrl ?? "",
                      errorWidget: (context, url, error) {
                        return const Center(child: SizedBox());
                      }),
                )),
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
                Material(
                  color: Colors.transparent,
                  child: Text(
                    tank.name ?? "Tank Name",
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: Text(
                    "$tankTypeNonNullable ${tank.size != null && tank.measurementUnit != null ? "-" : ""} ${tank.size ?? ""}${tank.measurementUnit ?? ""}",
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
