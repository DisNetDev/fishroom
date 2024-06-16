import 'package:flutter/material.dart';

import '../../../core/widgets/material_container.dart';

class TankTile extends StatelessWidget {
  const TankTile({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: MaterialContainer(
        onTap: () {},
        margin: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              offset: Offset(12, 12),
              color: Colors.black,
            )
          ],
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
