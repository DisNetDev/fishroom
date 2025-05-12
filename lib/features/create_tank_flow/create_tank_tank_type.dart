import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/features/create_tank_flow/create_tank_upload_photo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/constants.dart';
import '../../core/usecases/show_toast.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/text_input.dart';

class CreateTankTankType extends StatefulWidget {
  const CreateTankTankType(
      {super.key, required this.tank, required this.editTank});

  final Tank tank;
  final bool editTank;

  @override
  State<CreateTankTankType> createState() => _CreateTankTankTypeState();
}

class _CreateTankTankTypeState extends State<CreateTankTankType> {
  Tank get tank => widget.tank;
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
                "What type of tank do you have?",
                style: kHeadingTextStyle,
                textAlign: TextAlign.center,
              ),
              Gap(50),
              Text(
                "Eg. Freshwater, Saltwater, Brackish...\nCan be a certain Biotope...\nAmazonian, Tanganyikan.\n\nYour imagination is the limit!",
                style: kHeading2TextStyle,
                textAlign: TextAlign.center,
              ),
              const Gap(20),
              TextInput(
                  initialValue: tank.type,
                  onEditingComplete: () => onComplete(),
                  onChanged: (p0) => setState(() => tank.type = p0)),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child:
                CustomButton(text: "Continue", onPressed: () => onComplete())),
      ]),
    );
  }

  void onComplete() async {
    if (tank.type == null || tank.type == "") {
      showToast(context,
          title: "Your tank needs a type!",
          toastType: ToastType.error,
          description: 'Even if its just "Freshwater" :)');
    } else {
      tank.type = tank.type?.trim();
      await Future.delayed(const Duration(milliseconds: 400), () {});

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateTankUploadPhoto(
                  tank: tank, editTank: widget.editTank)));
    }
  }
}
