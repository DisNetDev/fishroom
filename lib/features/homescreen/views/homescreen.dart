import 'package:flutter/material.dart';
import '../widgets/tank_tile.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          TankTile(),
          TankTile(),
          TankTile(),
          TankTile(),
          TankTile(),
          TankTile(),
          TankTile(),
          TankTile(),
        ],
      ),
    );
  }
}
