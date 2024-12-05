import 'package:fishroom/features/tank_reading/models/parameter.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/usecases/is_dark_mode.dart';

class ParameterListWidget extends StatelessWidget {
  const ParameterListWidget(
      {super.key, required this.parameter, required this.onDismissed});

  final Parameter parameter;
  final Function() onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(parameter),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you want to delete?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        );
        if (confirm == true) {
          onDismissed();
        }

        return confirm == true;
      },
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.red,
            isDarkMode(context) ? Colors.transparent : Colors.white
          ]),
        ),
        alignment: Alignment.centerRight,
        child: Icon(Symbols.delete, color: Colors.orange.shade900),
      ),
      child: ListTile(
        leading: Icon(Symbols.water_drop, fill: 0.8),
        onTap: () {},
        title: Text(parameter.shortName ?? "Name Not Found"),
        subtitle: Text(parameter.name ?? "Description Not Found"),
        trailing: Icon(Symbols.edit, fill: 0.8),
      ),
    );
  }
}
