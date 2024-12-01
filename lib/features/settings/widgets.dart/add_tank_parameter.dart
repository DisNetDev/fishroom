import 'dart:math';

import 'package:animations/animations.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/fish_text_box.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/tank_reading/models/parameter.dart';
import 'package:fishroom/features/tank_reading/usecases/calculate_values_for_parameter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/constants.dart';

class AddTankParameter extends StatelessWidget {
  const AddTankParameter({super.key, required this.onParameterAdded});

  final void Function(Parameter) onParameterAdded;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        closedColor: isDarkMode(context) ? Colors.black : Colors.white,
        openColor: isDarkMode(context) ? Colors.black : Colors.white,
        closedBuilder: (BuildContext context, action) => Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: const GradientBoxBorder(gradient: kPrimaryGradient),
              ),
              child: const Icon(Symbols.add),
            ),
        openBuilder: (BuildContext context, action) =>
            _OpenWidget(onParameterAdded: onParameterAdded));
  }
}

class _OpenWidget extends StatefulWidget {
  const _OpenWidget({required this.onParameterAdded});

  final void Function(Parameter) onParameterAdded;

  @override
  State<_OpenWidget> createState() => _OpenWidgetState();
}

class _OpenWidgetState extends State<_OpenWidget> {
  Parameter parameter = Parameter();
  double _startDragX = 0;
  static const int _dragDistanceToGoBack =
      60; // How far the user has to drag to go back in pixels

  @override
  Widget build(BuildContext context) {
    List<double> values = calculateValuesForParameter(parameter);
    double valuesItemExtent = 30;

    if (parameter.step.toString().length > 4) {
      valuesItemExtent = parameter.step.toString().length * 10 - 10;
    }

    return GestureDetector(
      // Since the back gesture doesnt work on this widget, we need to detect the drag and close it
      onHorizontalDragStart: (details) {
        _startDragX = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (details) {
        double dragDistance = details.globalPosition.dx - _startDragX;
        if (dragDistance.abs() > _dragDistanceToGoBack) {
          Navigator.of(context).pop();
        }
      },
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(30),
                const Text("Add Parameter",
                    textAlign: TextAlign.center, style: kHeadingTextStyle),
                const Gap(30),
                TextInput(
                  label: const Text("Name"),
                  exampleText: "E.g.: Nitrate",
                  initialValue: parameter.name ?? "",
                  onChanged: (p0) => parameter = parameter.copyWith(name: p0),
                ),
                const Gap(30),
                TextInput(
                  label: const Text("Short Name"),
                  characterLimit: 3,
                  exampleText: "E.g. : NO3- (Max 3 characters)",
                  initialValue: parameter.shortName ?? "",
                  onChanged: (p0) =>
                      parameter = parameter.copyWith(shortName: p0),
                ),
                const Gap(30),
                TextInput(
                  label: const Text("Measurement Unit"),
                  characterLimit: 3,
                  exampleText: "E.g. : ppm (Max 3 characters)",
                  initialValue: parameter.unit ?? "",
                  onChanged: (p0) => parameter = parameter.copyWith(unit: p0),
                ),
                const Gap(30),
                const Gap(30),
                FishTextBox(
                    hintText: "Optional Description",
                    initialValue: parameter.description ?? "",
                    onChanged: (p0) =>
                        parameter = parameter.copyWith(description: p0)),
                const Gap(30),
                TextInput(
                  keyboardType: TextInputType.number,
                  label: const Text("Maximum Value"),
                  exampleText:
                      "The highest value you would ever test. E.g. : 100",
                  initialValue: parameter.max?.toString() ?? "",
                  onChanged: (p0) => setState(
                    () => parameter =
                        parameter.copyWith(max: double.tryParse(p0) ?? 0),
                  ),
                ),
                const Gap(20),
                TextInput(
                  keyboardType: TextInputType.number,
                  label: const Text("Minimum Value"),
                  exampleText: "The lowest value you would ever test. E.g. : 0",
                  initialValue: parameter.min?.toString() ?? "",
                  onChanged: (p0) => setState(
                    () => parameter =
                        parameter.copyWith(min: double.tryParse(p0) ?? 0),
                  ),
                ),
                const Gap(20),
                TextInput(
                    characterLimit: 5,
                    keyboardType: TextInputType.number,
                    label: const Text("Increments"),
                    exampleText:
                        "The increments between values. E.g. : 0.1 \n (Max 5 characters)",
                    initialValue: parameter.step?.toString() ?? "",
                    onChanged: (p0) => setState(
                          () => parameter = parameter.copyWith(
                              step: double.tryParse(p0) ?? 0),
                        )),
                const Gap(30),
                const Text(
                  "These will be the values available based on your settings:",
                  textAlign: TextAlign.center,
                ),
                if (values.length >= 500)
                  const Text(
                    "You have too many values to display them all. Try a smaller range.",
                    textAlign: TextAlign.center,
                    style: kHintTextStyle,
                  ),
                RotatedBox(
                  quarterTurns: 3,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width,
                    width: 60,
                    child: ListWheelScrollView.useDelegate(
                      onSelectedItemChanged: (index) {},
                      diameterRatio: 1,
                      physics: const FixedExtentScrollPhysics(),
                      itemExtent: valuesItemExtent,
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: values.length,
                        builder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Transform.rotate(
                              angle: pi / 2,
                              child: Text(
                                values[index] % 1 == 0
                                    ? values[index].toStringAsFixed(0)
                                    : values[index].toString(),
                                style: kHeading1TextStyle,
                                textScaler: TextScaler.noScaling,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text("<- Swipe to rotate ->",
                        style: kDateTimeTextStyle)),
                const Gap(50),
                CustomButton(
                    text: "Save Parameter",
                    onPressed: () {
                      widget.onParameterAdded(parameter);
                      Navigator.of(context).pop();
                    }),
                Gap(10),
                CustomButton(
                    primary: false,
                    text: "Cancel",
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                const Gap(50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
