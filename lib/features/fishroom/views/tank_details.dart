import 'package:fish_man/core/widgets/root_appbar.dart';
import 'package:fish_man/core/widgets/root_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      appBar: const RootSliverAppBar(
        title: "Tank Details",
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Hero(
                tag: "tank-${tank.id}-image",
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
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
              ),
              Positioned(
                child: Hero(
                  tag: "tank-${tank.id}",
                  transitionOnUserGestures: true,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
