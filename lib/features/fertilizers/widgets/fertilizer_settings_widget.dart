import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/features/fertilizers/models/fertilizer.dart';
import 'package:flutter/material.dart';

class FertilizerSettingsWidget extends StatelessWidget {
  const FertilizerSettingsWidget(
      {super.key,
      required this.fertilizer,
      required this.onTap,
      required this.onDismissed});

  final Fertilizer fertilizer;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return NeoBruteBorder(
      showShadow: false,
      child: Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepOrange,
                const Color.fromARGB(0, 255, 86, 34),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 20),
            ],
          ),
        ),
        key: Key(fertilizer.id),
        onDismissed: (_) => onDismissed(),
        child: ListTile(
            leading: Icon(Icons.water_drop),
            trailing: Icon(Icons.edit),
            title: Text(fertilizer.name),
            subtitle: Text(
                "${fertilizer.dosage}${fertilizer.dosageUnit} per ${fertilizer.perVolume}${fertilizer.perVolumeUnit}"),
            onTap: onTap),
      ),
    );
  }
}
