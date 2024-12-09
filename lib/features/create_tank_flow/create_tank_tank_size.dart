import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/features/create_tank_flow/create_tank_tank_type.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/constants.dart';
import '../../core/usecases/show_toast.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/text_input.dart';

class CreateTankTankSize extends StatefulWidget {
  const CreateTankTankSize(
      {super.key, required this.tank, this.editTank = false});

  final Tank tank;
  final bool editTank;

  @override
  State<CreateTankTankSize> createState() => _CreateTankTankSizeState();
}

class _CreateTankTankSizeState extends State<CreateTankTankSize> {
  FocusNode measurementFocusNode = FocusNode();
  FocusNode sizeFocusNode = FocusNode();
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
                "What size is your tank?",
                style: kHeadingTextStyle,
                textAlign: TextAlign.center,
              ),
              Gap(50),
              Text(
                "What will you be measuring in?",
                style: kHeading2TextStyle,
                textAlign: TextAlign.center,
              ),
              TextInput(
                  initialValue: tank.measurementUnit,
                  hintText: "Gallons, Litres, Feet, Cm's, etc.",
                  focusNode: measurementFocusNode,
                  onEditingComplete: () => sizeFocusNode.requestFocus(),
                  onChanged: (p0) => setState(() => tank.measurementUnit = p0)),
              Gap(50),
              Text(
                "How many ${tank.measurementUnit == "" || tank.measurementUnit == null ? "_______" : tank.measurementUnit} is your tank?",
                style: kHeading2TextStyle,
                textAlign: TextAlign.center,
              ),
              TextInput(
                  initialValue: tank.size != null ? tank.size.toString() : "",
                  focusNode: sizeFocusNode,
                  keyboardType: TextInputType.number,
                  onEditingComplete: () => onComplete(),
                  onChanged: (p0) =>
                      setState(() => tank.size = int.tryParse(p0))),
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

  void onComplete() {
    if (tank.size == null || tank.size == 0 || tank.measurementUnit == null) {
      showToast(context,
          title: "Your tank needs a size!", toastType: ToastType.error);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CreateTankTankType(tank: tank, editTank: widget.editTank)));
    }
  }
}
