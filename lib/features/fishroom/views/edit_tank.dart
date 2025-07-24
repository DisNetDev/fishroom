// ignore_for_file: use_build_context_synchronously, unused_element

import 'dart:io';

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/tank.dart';
import '../../../core/usecases/show_toast.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/root_sliver_app_bar.dart';
import '../../../core/widgets/text_input.dart';
import '../cubit/tanks_cubit.dart';
import '../widgets/image_upload_widget.dart';

class EditTank extends StatefulWidget {
  const EditTank({super.key, required this.tank});

  final Tank tank;

  @override
  State<EditTank> createState() => _EditTankState();
}

class _EditTankState extends State<EditTank> {
  bool loading = false;
  Tank tank = Tank(
    id: const Uuid().v4(),
  );
  File? _image;

  List<bool> tankTypeSelection = [false, false, false];

  void setTankTypeSelectionOnInit() {
    switch (widget.tank.type) {
      case "Freshwater":
        tankTypeSelection = [true, false, false];
        break;

      case "Saltwater":
        tankTypeSelection = [false, true, false];
        break;

      case "Brackish":
        tankTypeSelection = [false, false, true];
        break;
    }
  }

  void setImage() {
    if (widget.tank.imageLocalPath != null) {
      _image = File(widget.tank.imageLocalPath!);
    }
  }

  @override
  void initState() {
    setTankTypeSelectionOnInit();
    tank = widget.tank.copyWith();
    setImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        const CustomBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const RootSliverAppBar(title: "Edit a Tank"),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextInput(
                  initialValue: widget.tank.name,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  label: const Text("Tank Name"),
                  onChanged: (value) {
                    setState(() {
                      tank.name = value;
                    });
                  },
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextInput(
                      initialValue: widget.tank.size != null
                          ? widget.tank.size.toString()
                          : "",
                      margin: const EdgeInsets.all(0),
                      onChanged: (value) {
                        setState(
                          () {
                            tank.size = int.tryParse(value);
                          },
                        );
                      },
                      keyboardType: TextInputType.number,
                      label: const Text("Tank Capacity"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _CapacityButton(
                            measurementUnit: "L",
                            isSelected: tank.measurementUnit == "L",
                            onTap: () {
                              setState(
                                () {
                                  tank.measurementUnit = "L";
                                },
                              );
                            },
                          ),
                          _CapacityButton(
                            measurementUnit: "Gal",
                            isSelected: tank.measurementUnit == "Gal",
                            onTap: () {
                              setState(
                                () {
                                  tank.measurementUnit = "Gal";
                                },
                              );
                            },
                          ),
                          _CapacityButton(
                            measurementUnit: "ft",
                            isSelected: tank.measurementUnit == "ft",
                            onTap: () {
                              setState(
                                () {
                                  tank.measurementUnit = "ft";
                                },
                              );
                            },
                          ),
                          _CapacityButton(
                            measurementUnit: "cm",
                            isSelected: tank.measurementUnit == "cm",
                            onTap: () {
                              setState(
                                () {
                                  tank.measurementUnit = "cm";
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: isDarkTheme ? Colors.black26 : Colors.transparent,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: ToggleButtons(
                    borderColor: Colors.black26,
                    selectedBorderColor: kPrimaryColor,
                    constraints: BoxConstraints(
                        minHeight: 45,
                        minWidth: MediaQuery.of(context).size.width /
                                tankTypeSelection.length -
                            12),
                    borderRadius: BorderRadius.circular(1000),
                    onPressed: (index) {
                      for (int i = 0; i < tankTypeSelection.length; i++) {
                        tankTypeSelection[i] = false;
                      }
                      setState(() {
                        tankTypeSelection[index] = true;
                        tank.type = index == 0
                            ? "Freshwater"
                            : index == 1
                                ? "Saltwater"
                                : "Brackish";
                      });
                    },
                    isSelected: tankTypeSelection,
                    children: const [
                      Text("Freshwater"),
                      Text("Saltwater"),
                      Text("Brackish"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ImageUploadWidget(
                  onImagePicked: (image) => setState(
                    () => _image = image,
                  ),
                  image: _image,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                CustomButton(
                  loading: loading,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  text: "Edit",
                  onPressed: () async {
                    bool tankNameFilled = true;
                    bool tankSizeFilled = true;
                    bool tankTypeFilled = true;
                    String requiredFields = "";

                    if (tank.name == "") {
                      tankNameFilled = false;
                      requiredFields += "Tank Name, ";
                    }
                    if (tank.size == null) {
                      tankSizeFilled = false;
                      requiredFields += "Tank Size, ";
                    }
                    if (tank.type == "") {
                      tankTypeFilled = false;
                      requiredFields += "Tank Type, ";
                    }

                    if (!tankSizeFilled || !tankTypeFilled || !tankNameFilled) {
                      showToast(context,
                          toastType: ToastType.error,
                          title: "Missing Info",
                          description:
                              "${requiredFields.substring(0, requiredFields.length - 2)}.");
                    } else {
                      setState(() => loading = true);
                      try {
                        await context
                            .read<TanksCubit>()
                            .updateTank(tank, _image);
                      } on Exception catch (e) {
                        fishLog(e.toString());
                        showToast(
                          context,
                          title: "Something went wrong.",
                          description: e.toString(),
                          toastType: ToastType.error,
                        );
                      }
                      setState(() => loading = false);

                      if (!context.read<TanksCubit>().state.error) {
                        Navigator.pop(context);
                        showToast(
                          context,
                          title: "Tank Edited!",
                          toastType: ToastType.success,
                        );
                      }
                    }
                  },
                ),
                const Gap(40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Function to show a confirmation dialog for deleting a tank
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text(
              "Are you sure you want to delete this tank?\nThis cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                try {
                  context.read<TanksCubit>().deleteTank(widget.tank);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } catch (e) {
                  showToast(context,
                      title: "Something went wrong.",
                      toastType: ToastType.error,
                      description: e.toString());
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}

class _CapacityButton extends StatelessWidget {
  const _CapacityButton({
    required this.measurementUnit,
    required this.isSelected,
    required this.onTap,
  });

  final String measurementUnit;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(),
        child: Text(
          measurementUnit,
          style: kHeading2TextStyle.copyWith(
            color: isSelected ? kPrimaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}
