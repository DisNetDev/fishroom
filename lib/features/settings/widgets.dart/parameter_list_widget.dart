import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/features/tank_reading/models/parameter.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ParameterListWidget extends StatelessWidget {
  const ParameterListWidget(
      {super.key,
      required this.parameter,
      required this.onDismissed,
      required this.onEdit});

  final Parameter parameter;
  final Function() onDismissed;
  final Function() onEdit;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: NeoBruteBorder(
        showShadow: false,
        child: Dismissible(
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
            padding: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.deepOrange,
                const Color.fromARGB(0, 244, 67, 54)
              ]),
            ),
            alignment: Alignment.centerRight,
            child: Icon(Symbols.delete, color: Colors.deepOrange),
          ),
          child: ListTile(
            leading: Icon(Symbols.water_drop, fill: 0.8),
            onTap: () {},
            title: Text(parameter.shortName ?? "Name Not Found"),
            subtitle: Text(parameter.name ?? "Description Not Found"),
            trailing: GestureDetector(
              onTap: () {
                onEdit();
              },
              child: Icon(Symbols.edit, fill: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
