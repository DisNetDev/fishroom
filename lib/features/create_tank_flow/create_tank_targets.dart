import 'package:collection/collection.dart';
import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/tank_reading/widgets/parameter_wheel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../core/constants.dart';
import '../../core/widgets/custom_button.dart';
import '../tank_reading/models/parameter.dart';
import 'create_tank_upload_photo.dart';

class CreateTankTargets extends StatefulWidget {
  const CreateTankTargets(
      {super.key, required this.tank, this.editTank = false});

  final Tank tank;
  final bool editTank;

  @override
  State<CreateTankTargets> createState() => _CreateTankTargetsState();
}

class _CreateTankTargetsState extends State<CreateTankTargets> {
  Tank get tank => widget.tank;
  List<Parameter> get parameters =>
      context.read<AppCubit>().state.settings.parameters;

  List<Target> targets = [];

  @override
  void initState() {
    targets = tank.targets;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomBackground(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap(50),
                  Text(
                    "Parameter Targets",
                    style: kHeadingTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  Gap(50),
                  Text(
                    "You can set targets for your tank parameters here.\nThis will help you keep track of your tank's health, by letting you know when parameters are off.\nThis is not required, you can just click continue to skip this step.\n\nIf you would like to add more parameters, you can do so in the settings page and come back here to edit them.\n Select your middle ground for each parameter.\n\nTolerance is one value to the left and right of your chosen value.",
                    style: kHeading2TextStyle,
                    textAlign: TextAlign.center,
                  ),
                  Gap(50),
                  ...parameters.map(
                    (e) => ParameterWheel(
                      initialValue: targets
                          .firstWhereOrNull(
                              (element) => element.paramID == e.id)
                          ?.value,
                      enabled:
                          targets.any((element) => element.paramID == e.id),
                      valueSelected: (valueSelected) {
                        targets
                            .firstWhere((element) => element.paramID == e.id)
                            .value = valueSelected;
                      },
                      parameter: e,
                      onTap: () {
                        setState(() {
                          if (targets
                              .any((element) => element.paramID == e.id)) {
                            targets.removeWhere(
                                (element) => element.paramID == e.id);
                          } else {
                            targets
                                .add(Target(paramID: e.id, value: e.min ?? 0));
                          }
                        });
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 50),
                      child: CustomButton(
                          text: "Continue", onPressed: () => onComplete())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onComplete() {
    tank.targets = targets;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CreateTankUploadPhoto(tank: tank, editTank: widget.editTank)));
  }
}
