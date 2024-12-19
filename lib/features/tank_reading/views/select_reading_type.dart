import 'dart:math';

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/features/tank_reading/views/create_tank_note.dart';
import 'package:fishroom/features/tank_reading/views/create_tank_reading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';

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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "What type of entry would you like to make?",
                textAlign: TextAlign.center,
                style: kHeadingTextStyle,
              ),
              Gap(20),
              _ItemList(
                  tank: tank,
                  title: "Parameter Reading",
                  subtitle: "Log a reading of the tank's parameters",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateTankReading(tank: tank)));
                  }),
              _ItemList(
                  tank: tank,
                  title: "Note",
                  subtitle: "Log a note about the tank",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateTankNote(tank: tank)));
                  }),
              _ItemList(
                  tank: tank,
                  title: "Water Change",
                  subtitle: "Log a water change",
                  onTap: () {}),
            ],
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
    required this.onTap,
  });

  final Tank tank;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: GradientBoxBorder(gradient: kPrimaryGradient),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text(
          title,
          style: kHeading2TextStyle,
        ),
        subtitle: Text(
          subtitle,
          style: kDateTimeTextStyle,
        ),
        onTap: onTap,
      ),
    );
  }
}
