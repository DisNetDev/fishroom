import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:fishroom/features/tank_reading/usecases/calculate_values_for_parameter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../core/models/tank.dart';
import '../../tank_reading/models/parameter.dart';
import 'tolerance_slider.dart';

class TargetSelector extends StatefulWidget {
  const TargetSelector({
    super.key,
    required this.parameter,
    this.initialTarget,
    this.enabled = true,
    required this.onTargetSelected,
    required this.onDelete,
  });

  final Parameter parameter;
  final Target? initialTarget;
  final bool enabled;
  final void Function(Target) onTargetSelected;
  final VoidCallback onDelete;

  @override
  State<TargetSelector> createState() => _TargetSelectorState();
}

class _TargetSelectorState extends State<TargetSelector> {
  double value = 0;
  double tolerance = 0;

  late Target target;
  late double maxValue;
  late double minValue;

  @override
  void initState() {
    super.initState();

    target = Target.fromTarget(widget.initialTarget ??
        Target(paramID: widget.parameter.id, value: 0, tolerance: 0));

    if (target.value > (widget.parameter.max ?? 20)) {
      target = target.copyWith(value: widget.parameter.max ?? 20);
    }
    if (target.value < (widget.parameter.min ?? 0)) {
      target = target.copyWith(value: widget.parameter.min ?? 0);
    }

    maxValue = widget.parameter.max ?? 20;
    minValue = widget.parameter.min ?? 0;
    value = widget.initialTarget?.value ?? widget.parameter.min ?? 0;
    tolerance = widget.initialTarget?.tolerance ?? 0;
  }

  List<double> get steps => calculateValuesForParameter(widget.parameter);

  double get valueClosestToStep =>
      steps.reduce((a, b) => (a - value).abs() < (b - value).abs() ? a : b);

  double get toleranceClosestToStep {
    final stepSize = widget.parameter.step ?? 1.0;

    return (tolerance / stepSize).round() * stepSize;
  }

  double get toleranceMin => valueClosestToStep - toleranceClosestToStep;
  double get toleranceMax => valueClosestToStep + toleranceClosestToStep;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Text(
              "${widget.parameter.name ?? ""} (${widget.parameter.shortName ?? ""})",
              style: kHeading1TextStyle,
            ),
            Gap(20),
            if (steps.isNotEmpty)
              ToleranceSlider(
                minValue: minValue,
                maxValue: maxValue,
                toleranceMin: toleranceMin,
                toleranceMax: toleranceMax,
              ),
            const Gap(25),
            Text(
              "Target",
              style: kDateTimeTextStyle,
            ),
            Slider(
              label: valueClosestToStep.toStringAsFixed(2),
              min: minValue,
              max: maxValue,
              value: target.value,
              onChanged: (returnedValue) => setState(() {
                value = returnedValue;
                target = target.copyWith(value: valueClosestToStep);
              }),
              onChangeEnd: (value) => widget.onTargetSelected(target),
            ),
            const Gap(10),
            Text(
              "Tolerance",
              style: kDateTimeTextStyle,
            ),
            Slider(
              min: 0,
              max: maxValue / 2,
              value: tolerance,
              label: toleranceClosestToStep.toStringAsFixed(2),
              onChanged: (value) => setState(() {
                tolerance = value;
                target = target.copyWith(tolerance: toleranceClosestToStep);
              }),
              onChangeEnd: (value) => widget.onTargetSelected(target),
            ),
            const Gap(30),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                border: GradientBoxBorder(
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    isDarkMode(context) ? kSecondaryColor : kPrimaryColor,
                    Colors.transparent
                  ]),
                  width: 0.5,
                ),
              ),
            )
          ],
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: widget.onDelete,
            child: Icon(
              Symbols.close,
              size: 20,
            ),
          ),
        )
      ],
    );
  }
}
