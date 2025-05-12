import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishroom/core/models/tank.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TankDetailsOverview extends StatelessWidget {
  const TankDetailsOverview({super.key, required this.tank});

  final Tank tank;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (tank.imageUrl != null)
          CachedNetworkImage(
            imageUrl: tank.imageUrl ?? "",
            width: 200,
            height: 200,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
              ),
            ),
          ),
        Gap(10),
        Text(
          tank.name ?? "Tank Details",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        Gap(20),
      ],
    );
  }
}
