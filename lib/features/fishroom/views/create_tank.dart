// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/tank.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../../core/usecases/show_toast.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/root_appbar.dart';
import '../../../core/widgets/text_input.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/tanks_cubit.dart';
import '../widgets/image_upload_widget.dart';

class CreateTank extends StatefulWidget {
  const CreateTank({super.key});

  @override
  State<CreateTank> createState() => _CreateTankState();
}

class _CreateTankState extends State<CreateTank> {
  bool loading = false;
  Tank tank = Tank(
    id: const Uuid().v4(),
  );
  File? _image;

  List<bool> tankTypeSelection = [false, false, false];

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: isDarkMode(context)
                      ? const AssetImage("assets/background_dark.png")
                      : const AssetImage("assets/background_light.png"))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Positioned(
          bottom: 0,
          child: Opacity(
            opacity: isDarkMode(context) ? 0.05 : 0.1,
            child: Image(
              image: const AssetImage(
                "assets/bottom_decoration.png",
              ),
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const RootSliverAppBar(title: "Create a Tank"),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextInput(
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
                  onImagePicked: (image) => _image = image,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                CustomButton(
                  loading: loading,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  text: "Create",
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
                      tank.createdAt = DateTime.now().toString();
                      tank.ownerId = context.read<AuthCubit>().state.user!.uuid;
                      try {
                        await context.read<TanksCubit>().addTank(tank, _image);
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
                          title: "Tank Created!",
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
