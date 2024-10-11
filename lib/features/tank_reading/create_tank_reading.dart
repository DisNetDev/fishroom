import 'dart:io';

import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/core/models/tank_reading.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/root_appbar.dart';
import 'package:fishroom/features/fishroom/cubit/tanks_cubit.dart';
import 'package:fishroom/features/fishroom/widgets/image_upload.dart';
import 'package:fishroom/features/tank_reading/usecases/parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants.dart';
import '../../core/usecases/is_dark_mode.dart';
import '../../core/widgets/text_box.dart';
import '../auth/cubit/auth_cubit.dart';
import 'widgets/parameter_wheel.dart';

class CreateTankReading extends StatefulWidget {
  const CreateTankReading({super.key, required this.tank});
  final Tank tank;

  @override
  State<CreateTankReading> createState() => _CreateTankReadingState();
}

class _CreateTankReadingState extends State<CreateTankReading> {
  bool loading = false;
  late TankReading tankReading = TankReading(
    id: const Uuid().v4(),
    ownerId: context.read<AuthCubit>().state.user!.uuid,
    type: TankReadingType.measurement,
    tankId: widget.tank.id,
    createdAt: DateTime.now().toString(),
  );
  List<bool> selectedTypeButtons = [true, false];

  double horizontalPadding = 12;
  XFile? _image;
  ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
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
          appBar: const RootSliverAppBar(title: "Add a Tank Reading"),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Gap(20),
                  Center(
                    child: ToggleButtons(
                        borderColor: isDarkMode(context)
                            ? Colors.blueGrey
                            : Colors.black26,
                        selectedBorderColor: kPrimaryColor,
                        constraints: BoxConstraints(
                            minHeight: 45,
                            minWidth: MediaQuery.of(context).size.width /
                                    selectedTypeButtons.length -
                                horizontalPadding -
                                2),
                        borderRadius: BorderRadius.circular(1000),
                        onPressed: (index) {
                          for (int i = 0; i < selectedTypeButtons.length; i++) {
                            selectedTypeButtons[i] = false;
                          }
                          setState(() {
                            selectedTypeButtons[index] = true;
                            if (selectedTypeButtons[0] == true) {
                              tankReading = tankReading.copyWith(
                                  type: TankReadingType.measurement);
                            } else {
                              tankReading = tankReading.copyWith(
                                  type: TankReadingType.note);
                            }
                          });
                        },
                        isSelected: selectedTypeButtons,
                        children: const [Text("Reading"), Text("Note")]),
                  ),
                  const Gap(20),
                  if (tankReading.type == TankReadingType.measurement)
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ParameterWheel(
                              valueSelected: (value) =>
                                  tankReading = tankReading.copyWith(ph: value),
                              parameter: readingParameters[0],
                              onEnabled: (value) {
                                if (value == true) {
                                  tankReading = tankReading.copyWith(ph: 4);
                                } else {
                                  tankReading.ph = null;
                                }
                              }),
                          ParameterWheel(
                              valueSelected: (value) =>
                                  tankReading = tankReading.copyWith(ta: value),
                              parameter: readingParameters[1],
                              onEnabled: (value) {
                                if (value == true) {
                                  tankReading = tankReading.copyWith(ta: 0);
                                } else {
                                  tankReading.ta = null;
                                }
                              }),
                          ParameterWheel(
                              valueSelected: (value) => tankReading =
                                  tankReading.copyWith(no2: value),
                              parameter: readingParameters[2],
                              onEnabled: (value) {
                                if (value == true) {
                                  tankReading = tankReading.copyWith(no2: 0);
                                } else {
                                  tankReading.no2 = null;
                                }
                              }),
                          ParameterWheel(
                              valueSelected: (value) => tankReading =
                                  tankReading.copyWith(no3: value),
                              parameter: readingParameters[3],
                              onEnabled: (value) {
                                if (value == true) {
                                  tankReading = tankReading.copyWith(no3: 0);
                                } else {
                                  tankReading.no3 = null;
                                }
                              }),
                          ParameterWheel(
                              valueSelected: (value) =>
                                  tankReading = tankReading.copyWith(gh: value),
                              parameter: readingParameters[4],
                              onEnabled: (value) {
                                if (value == true) {
                                  tankReading = tankReading.copyWith(gh: 0);
                                } else {
                                  tankReading.gh = null;
                                }
                              }),
                          ParameterWheel(
                              valueSelected: (value) =>
                                  tankReading = tankReading.copyWith(kh: value),
                              parameter: readingParameters[5],
                              onEnabled: (value) {
                                if (value == true) {
                                  tankReading = tankReading.copyWith(kh: 0);
                                } else {
                                  tankReading.kh = null;
                                }
                              }),
                        ]),
                  const Gap(20),
                  FishTextBox(
                    hintText: "Note",
                    onChanged: (value) => setState(
                        () => tankReading = tankReading.copyWith(note: value)),
                    initialValue: tankReading.note ?? "",
                  ),
                  const Gap(20),
                  ImageUpload(
                    image: _image,
                    onTap: () async {
                      final XFile? image = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      setState(() {
                        _image = image;
                      });
                    },
                  ),
                  const Gap(50),
                  CustomButton(
                      loading: loading,
                      text: "Save",
                      onPressed: () async {
                        setState(() => loading = true);
                        try {
                          await context.read<TanksCubit>().createTankReading(
                                tankReading,
                                _image == null ? null : File(_image!.path),
                              );
                          setState(() => loading = false);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        } on Exception catch (e) {
                          if (context.mounted) {
                            showToast(context,
                                title: "Something went wrong.",
                                description: e.toString(),
                                toastType: ToastType.error);
                            setState(() => loading = false);
                          }
                        }
                      }),
                  const Gap(50),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
