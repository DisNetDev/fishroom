import 'package:fishroom/core/widgets/root_appbar.dart';
import 'package:fishroom/core/widgets/root_drawer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';
import '../widgets/tank_entry_list_item.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      endDrawer: const RootDrawer(),
      appBar: RootSliverAppBar(
        title: tank.name ?? "Tank Details",
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                for (int i = 0; i < 10; i++)
                  TankEntryListItem(
                    reading: TankReading(
                      id: "1",
                      type: TankReadingType.measurement,
                      tankId: tank.id,
                      dateTime: DateTime.now().toString(),
                      note: "Note",
                    ),
                  ),
                const Gap(300),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Hero(
                tag: "tank-${tank.id}",
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black,
                            Colors.transparent,
                            Colors.transparent
                          ],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 16 * 9,
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
                      bottom: 20,
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
                                style: kHeading1TextStyle.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Text(
                                "$tankTypeNonNullable - ${tank.size}${tank.measurementUnit}",
                                style: kHeading2TextStyle.copyWith(
                                  color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }
}
