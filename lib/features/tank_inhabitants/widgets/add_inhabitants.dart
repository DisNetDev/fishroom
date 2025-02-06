import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/usecases/nav_push.dart';
import '../models/inhabitant.dart';
import '../views/add_inhabitants_view.dart';

class AddInhabitants extends StatelessWidget {
  const AddInhabitants(
      {super.key, required this.tank, required this.chosenInhabitant});

  final Tank tank;
  final void Function(Inhabitant) chosenInhabitant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navPush(context,
            AddInhabitantsView(tank: tank, chosenInhabitant: chosenInhabitant));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: GradientBoxBorder(
            gradient: kPrimaryGradient,
          ),
        ),
        child: Row(
          spacing: 20,
          children: [
            Icon(Icons.add, size: 20),
            Text("Add tank inhabitants..."),
          ],
        ),
      ),
    );
  }
}
