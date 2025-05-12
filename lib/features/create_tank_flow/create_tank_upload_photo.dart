// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/features/fishroom/cubit/tanks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../core/constants.dart';
import '../../core/usecases/show_toast.dart';
import '../../core/widgets/custom_background.dart';
import '../../core/widgets/custom_button.dart';
import '../fishroom/widgets/image_upload_widget.dart';

class CreateTankUploadPhoto extends StatefulWidget {
  const CreateTankUploadPhoto(
      {super.key, required this.tank, required this.editTank});

  final Tank tank;
  final bool editTank;

  @override
  State<CreateTankUploadPhoto> createState() => CreateTankUploadPhotoState();
}

class CreateTankUploadPhotoState extends State<CreateTankUploadPhoto> {
  Tank get tank => widget.tank;
  File? _image;
  bool loading = false;

  setImage() {
    if (widget.tank.imageLocalPath != null) {
      _image = File(widget.tank.imageLocalPath!);
    }
  }

  @override
  void initState() {
    if (widget.editTank) {
      setImage();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.bottomCenter, children: [
        CustomBackground(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Upload a photo for your tank!",
                style: kHeadingTextStyle,
                textAlign: TextAlign.center,
              ),
              Gap(50),
              Text(
                "Tip: To get the best looking thumbnail, \nthe image should be landscape, \n16:9 ratio and the tank should fill the whole photo.",
                style: kHeading2TextStyle,
                textAlign: TextAlign.center,
              ),
              Gap(20),
              ImageUploadWidget(
                image: _image,
                onImagePicked: (image) => setState(
                  () => _image = image,
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: CustomButton(
                loading: loading,
                text: "Continue",
                onPressed: () => onComplete())),
      ]),
    );
  }

  void onComplete() async {
    try {
      setState(() => loading = true);
      if (!widget.editTank) {
        await context.read<TanksCubit>().addTank(tank, _image);
      } else {
        await context.read<TanksCubit>().updateTank(tank, _image);
      }
      setState(() => loading = false);

      while (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => loading = false);
      showToast(context,
          title: "Whoops!",
          toastType: ToastType.error,
          description: e.toString());
    }
  }
}
