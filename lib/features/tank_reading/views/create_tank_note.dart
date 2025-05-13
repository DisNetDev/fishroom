import 'dart:io';

import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/core/models/tank_reading.dart';
import 'package:fishroom/core/usecases/is_pro_user.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/usecases/pick_image.dart';
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

import '../../../core/constants.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../../core/widgets/fish_text_box.dart';
import '../../app/cubit/app_cubit.dart';

class CreateTankNote extends StatefulWidget {
  const CreateTankNote({super.key, required this.tank});
  final Tank tank;

  @override
  State<CreateTankNote> createState() => _CreateTankNoteState();
}

class _CreateTankNoteState extends State<CreateTankNote> {
  bool loading = false;
  late TankReading tankReading = TankReading(
    id: const Uuid().v4(),
    ownerId: context.read<AppCubit>().state.user!.uuid,
    type: TankReadingType.note,
    tankId: widget.tank.id,
    createdAt: DateTime.now().toString(),
  );
  List<bool> selectedTypeButtons = [true, false];

  double horizontalPadding = 12;
  File? _image;
  ImagePicker imagePicker = ImagePicker();

  List<Parameter> parameters = [];

  @override
  void initState() {
    tankReading = TankReading(
      id: const Uuid().v4(),
      ownerId: context.read<AppCubit>().state.user!.uuid,
      type: TankReadingType.note,
      tankId: widget.tank.id,
      createdAt: DateTime.now().toString(),
    );

    parameters.addAll(context.read<AppCubit>().state.settings.parameters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const CustomBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: [
              RootSliverAppBar(
                title: "Create Note",
                sliver: true,
              ),
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FishTextBox(
                          hintText: "Note",
                          onChanged: (value) => setState(
                            () =>
                                tankReading = tankReading.copyWith(note: value),
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
                                    setState(() {});
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
                        else if (!isProUser(context) && _image == null)
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
                            unlockAspectRatio: true,
                            onImagePicked: (image) =>
                                setState(() => _image = image),
                          ),
                        const Gap(100),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 16),
                          child: CustomButton(
                              loading: loading,
                              text: "Save",
                              onPressed: () async {
                                setState(() => tankReading = tankReading
                                    .copyWith(note: tankReading.note?.trim()));
                                if (tankReading.note == null ||
                                    tankReading.note!.isEmpty) {
                                  showToast(context,
                                      title: "Please add a note.",
                                      toastType: ToastType.info);
                                  return;
                                }
                                setState(() => loading = true);
                                try {
                                  await context
                                      .read<TanksCubit>()
                                      .createTankReading(
                                        tankReading,
                                        _image,
                                      );
                                  setState(() => loading = false);
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
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
          ),
        ),
      ],
    );
  }
}
