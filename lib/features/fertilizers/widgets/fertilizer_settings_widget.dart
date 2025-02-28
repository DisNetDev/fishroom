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
    return Dismissible(
      key: Key(fertilizer.id),
      onDismissed: (_) => onDismissed(),
      child: ListTile(
          leading: Icon(Icons.water_drop),
          trailing: Icon(Icons.edit),
          title: Text(fertilizer.name),
          subtitle: Text("${fertilizer.dosage} per ${fertilizer.perVolume}"),
          onTap: onTap),
    );
  }
}
