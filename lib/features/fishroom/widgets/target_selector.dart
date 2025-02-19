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

  @override
  void initState() {
    super.initState();
    target = Target.fromTarget(widget.initialTarget ??
        Target(paramID: widget.parameter.id, minValue: 0, maxValue: 0));
  }

  double get toleranceMinInSteps =>
      calculateValuesForParameter(widget.parameter).reduce((closest, current) =>
          (current - target.minValue).abs() < (closest - target.minValue).abs()
              ? current
              : closest);
  double get toleranceMaxInSteps =>
      calculateValuesForParameter(widget.parameter).reduce((closest, current) =>
          (current - target.maxValue).abs() < (closest - target.maxValue).abs()
              ? current
              : closest);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Text(
              "${widget.parameter.name ?? ""} (${widget.parameter.shortName ?? ""})",
              style: kHeadingTextStyle,
            ),
            Gap(10),
            ToleranceSlider(
              parameter: widget.parameter,
              minValue: widget.parameter.min ?? 0,
              maxValue: widget.parameter.max ?? 0,
              toleranceMin: toleranceMinInSteps,
              toleranceMax: toleranceMaxInSteps,
              onChanged: (toleranceMin, toleranceMax) => {
                setState(
                  () {
                    target = Target(
                        paramID: widget.parameter.id,
                        minValue: toleranceMin,
                        maxValue: toleranceMax);
                  },
                ),
                widget.onTargetSelected(target),
              },
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
