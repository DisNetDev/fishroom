import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/features/tank_reading/views/create_tank_note.dart';
import 'package:fishroom/features/tank_reading/views/create_tank_reading.dart';
import 'package:fishroom/features/tank_reading/views/fertilizer_reading.dart';
import 'package:fishroom/features/tank_reading/views/water_change_reading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/models/tank.dart';

class SelectReadingType extends StatelessWidget {
  const SelectReadingType({super.key, required this.tank});

  final Tank tank;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomBackground(),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "What type of entry would you like to make?",
                        textAlign: TextAlign.center,
                        style: kHeadingTextStyle,
                      ),
                    ),
                    Gap(20),
                    _ItemList(
                        tank: tank,
                        title: "Parameter Reading",
                        subtitle: "Log a reading of the tank's parameters.",
                        onTap: () {
                          navPush(context, CreateTankReading(tank: tank));
                        }),
                    _ItemList(
                        tank: tank,
                        title: "Note",
                        subtitle: "Log a note about the tank.",
                        subsubtitle:
                            "Not counted towards the 'The Abandoned' achievement.",
                        onTap: () {
                          navPush(context, CreateTankNote(tank: tank));
                        }),
                    _ItemList(
                        tank: tank,
                        title: "Water Change",
                        subtitle: "Log a water change.",
                        onTap: () {
                          navPush(context, WaterChangeReading(tank: tank));
                        }),
                    _ItemList(
                        tank: tank,
                        title: "Fertilizer Dose",
                        subtitle: "Log a fertilizer dose.",
                        onTap: () {
                          navPush(context, FertilizerReading(tank: tank));
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({
    required this.tank,
    required this.title,
    required this.subtitle,
    this.subsubtitle,
    required this.onTap,
  });

  final Tank tank;
  final String title;
  final String subtitle;
  final String? subsubtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: NeoBruteBorder(
        child: ListTile(
          title: Text(
            title,
            style: kHeading1TextStyle,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: kHeading2TextStyle,
              ),
              if (subsubtitle != null) Gap(5),
              if (subsubtitle != null)
                Text(
                  subsubtitle!,
                  style: kDateTimeTextStyle,
                ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
