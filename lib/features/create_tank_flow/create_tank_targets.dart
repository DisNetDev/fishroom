import 'package:collection/collection.dart';
import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/constants.dart';
import '../../core/usecases/is_dark_mode.dart';
import '../../core/widgets/custom_button.dart';
import '../fishroom/widgets/target_selector.dart';
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

  List<Parameter> get unselectedParameters => parameters
      .where((parameter) =>
          !targets.any((target) => target.paramID == parameter.id))
      .toList();

  List<Target> targets = [];

  @override
  void initState() {
    targets.addAll(tank.targets);
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
                    "You can set targets for your tank parameters here.\nThis will help you keep track of your tank's health, by letting you know when parameters are off.",
                    style: kHeading2TextStyle,
                    textAlign: TextAlign.center,
                  ),
                  Gap(50),
                  Wrap(
                    children: List.generate(
                      unselectedParameters.length,
                      (index) => _ParamChip(
                        parameter: unselectedParameters[index],
                        onTap: () {
                          setState(
                            () => targets.add(
                              Target(
                                  paramID: parameters
                                      .firstWhere((parameter) =>
                                          parameter.id ==
                                          unselectedParameters[index].id)
                                      .id,
                                  minValue: parameters
                                          .firstWhere((parameter) =>
                                              parameter.id ==
                                              unselectedParameters[index].id)
                                          .min ??
                                      0,
                                  maxValue: parameters
                                          .firstWhere((parameter) =>
                                              parameter.id ==
                                              unselectedParameters[index].id)
                                          .max ??
                                      0),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (unselectedParameters.isNotEmpty) Gap(30),
                  ...List.generate(
                    targets.length,
                    (index) => TargetSelector(
                      onDelete: () {
                        setState(() => targets.removeAt(index));
                      },
                      parameter: parameters.firstWhere((parameter) =>
                          parameter.id == targets[index].paramID),
                      initialTarget: targets.firstWhereOrNull(
                          (target) => target.paramID == targets[index].paramID),
                      onTargetSelected: (target) {
                        int targetIndex = targets.indexWhere((target) =>
                            target.paramID == targets[index].paramID);
                        targets[targetIndex] = target;
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 50),
                      child: CustomButton(
                          text: targets.isEmpty ? "Skip" : "Continue",
                          onPressed: () => onComplete())),
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

class _ParamChip extends StatelessWidget {
  const _ParamChip({required this.parameter, required this.onTap});

  final Parameter parameter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: double.infinity,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isDarkMode(context) ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDarkMode(context) ? Colors.white : Colors.grey.shade400,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${parameter.name ?? ""} (${parameter.shortName ?? ""})"),
            Gap(10),
            Icon(
              Symbols.add,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
