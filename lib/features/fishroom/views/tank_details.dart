import 'package:fishroom/core/widgets/root_appbar.dart';
import 'package:fishroom/core/widgets/root_drawer.dart';
import 'package:flutter/material.dart';

import '../../../core/models/tank.dart';

class TankDetails extends StatelessWidget {
  const TankDetails({super.key, required this.tank});

  final Tank tank;

  @override
  Widget build(BuildContext context) {
    String tankTypeNonNullable = tank.type ?? "Tank Type";
    if (tankTypeNonNullable == "") {
      tankTypeNonNullable = "Tank Type";
    }
    return Scaffold(
      endDrawer: const RootDrawer(),
      appBar: RootSliverAppBar(
        title: tank.name ?? "Tank Details",
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Hero(
            tag: "tank-${tank.id}",
            child: Stack(
              alignment: Alignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(tank.image?.path ?? ""),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                          Colors.transparent
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            tank.name ?? "Tank name not found",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            "$tankTypeNonNullable - ${tank.size}${tank.measurementUnit}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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
