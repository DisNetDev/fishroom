import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/models/tank.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_shadow/simple_shadow.dart';

class TankDetailsOverview extends StatelessWidget {
  const TankDetailsOverview({super.key, required this.tank});

  final Tank tank;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (tank.imageUrl != null)
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 5,
                decoration: BoxDecoration(color: kTertiaryColor),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                  border: Border.all(color: kTertiaryColor, width: 2),
                ),
                child: SimpleShadow(
                  offset: const Offset(5, 5),
                  color: kTertiaryColor,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: tank.imageUrl ?? "",
                      width: 150,
                      height: 150,
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
                  ),
                ),
              ),
            ],
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
