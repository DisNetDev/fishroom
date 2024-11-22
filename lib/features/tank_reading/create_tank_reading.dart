import 'dart:io';

import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/core/models/tank_reading.dart';
import 'package:fishroom/core/usecases/is_pro_user.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/usecases/upload_image.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/fishroom/cubit/tanks_cubit.dart';
import 'package:fishroom/features/fishroom/widgets/image_upload_widget.dart';
import 'package:fishroom/features/tank_reading/models/parameter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants.dart';
import '../../core/usecases/is_dark_mode.dart';
import '../../core/widgets/fish_text_box.dart';
import '../auth/cubit/app_cubit.dart';
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
    ownerId: context.read<AppCubit>().state.user!.uuid,
    type: TankReadingType.measurement,
    tankId: widget.tank.id,
    createdAt: DateTime.now().toString(),
  );
  List<bool> selectedTypeButtons = [true, false];

  double horizontalPadding = 12;
  File? _image;
  ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const CustomBackground(),
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
                            if (selectedTypeButtons[0]) {
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
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ParameterWheel(
                              valueSelected: (value) =>
                                  tankReading = tankReading.copyWith(ph: value),
                              parameter: readingParameters[0],
                              onEnabled: (value) {
                                if (value) {
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
                                if (value) {
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
                                if (value) {
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
                                if (value) {
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
                                if (value) {
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
                                if (value) {
                                  tankReading = tankReading.copyWith(kh: 0);
                                } else {
                                  tankReading.kh = null;
                                }
                              }),
                          ParameterWheel(
                              valueSelected: (value) => tankReading =
                                  tankReading.copyWith(tds: value),
                              parameter: readingParameters[6],
                              onEnabled: (value) {
                                if (value) {
                                  tankReading = tankReading.copyWith(tds: 0);
                                } else {
                                  tankReading.tds = null;
                                }
                              }),
                        ]),
                  const Gap(20),
                  FishTextBox(
                    hintText: "Note",
                    onChanged: (value) => setState(
                      () => tankReading = tankReading.copyWith(note: value),
                    ),
                    initialValue: tankReading.note ?? "",
                  ),
                  const Gap(20),
                  if (isProUser(context) && _image == null)
                    Column(
                      children: [
                        CustomButton(
                            primary: false,
                            text: "Attach a Photo",
                            onPressed: () async {
                              _image = await pickImage(context);
                            }),
                        const Gap(20),
                        Text(
                          "Disclaimer, although we do compress images, minimal damage is made to the image quality. However, you should always backup your high quality original photos.",
                          textAlign: TextAlign.center,
                          style: kHintTextStyle.copyWith(
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    )
                  else if (isProUser(context) && _image == null)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: isDarkMode(context)
                                  ? Colors.grey
                                  : Colors.black),
                          borderRadius: BorderRadius.circular(1000)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Symbols.lock,
                            color: Colors.grey,
                          ),
                          Gap(20),
                          Text(
                            "Upgrade to Pro to upload a photo.",
                            style: kHintTextStyle,
                          ),
                        ],
                      ),
                    )
                  else
                    ImageUploadWidget(
                      image: _image,
                      onImagePicked: (image) => setState(() => _image = image),
                    ),
                  const Gap(100),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 16),
                    child: CustomButton(
                        loading: loading,
                        text: "Save",
                        onPressed: () async {
                          setState(() => loading = true);
                          try {
                            await context.read<TanksCubit>().createTankReading(
                                  tankReading,
                                  _image,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
