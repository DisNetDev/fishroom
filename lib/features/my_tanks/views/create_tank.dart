import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fish_man/core/widgets/fishy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/tank.dart';
import '../../../core/widgets/root_appbar.dart';
import '../cubit/tanks_cubit.dart';

class CreateTank extends StatefulWidget {
  const CreateTank({super.key});

  @override
  State<CreateTank> createState() => _CreateTankState();
}

class _CreateTankState extends State<CreateTank> {
  String _tankName = "";
  final String _tankType = "";
  String _tankSize = "";
  String _measurementUnit = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const RootSliverAppBar(title: "Create a Tank"),
        body: Column(
          children: [
            TextField(
              onChanged: (value) {
                _tankName = value;
              },
              decoration: const InputDecoration(
                hintText: "Tank Name",
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _tankSize = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Tank Capacity",
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownMenu(
                      onSelected: (value) {
                        setState(() {
                          _measurementUnit = value ?? "";
                        });
                      },
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: "L", label: "Liters"),
                        DropdownMenuEntry(value: "G", label: "Gallons"),
                      ]),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  if (_tankName == "" ||
                      _tankSize == "" ||
                      _measurementUnit == "") {
                    ScaffoldMessenger.of(context).showSnackBar(fishySnackBar(
                      title: "Missing Information",
                      message: "Please fill in all fields",
                      contentType: ContentType.warning,
                    ));
                    return;
                  }
                  context.read<TanksCubit>().addTank(Tank(
                      name: _tankName,
                      type: _tankType,
                      size: _tankSize,
                      measurementUnit: _measurementUnit));
                  ScaffoldMessenger.of(context).showSnackBar(fishySnackBar(
                      title: "Tank Created",
                      message: "Tank created successfully",
                      contentType: ContentType.success,
                      color: const Color.fromARGB(255, 0, 156, 21)));
                  Navigator.of(context).pop();
                },
                child: const Text("Create"))
          ],
        ));
  }
}
