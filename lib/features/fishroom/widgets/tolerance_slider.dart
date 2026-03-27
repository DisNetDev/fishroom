import 'package:fishroom/core/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants.dart';
import '../../tank_reading/models/parameter.dart';
import '../../tank_reading/usecases/calculate_values_for_parameter.dart';

class ToleranceSlider extends StatefulWidget {
  const ToleranceSlider(
      {super.key,
      required this.parameter,
      required this.minValue,
      required this.maxValue,
      required this.toleranceMin,
      required this.toleranceMax,
      required this.onChanged});

  final Parameter parameter;
  final double minValue;
  final double maxValue;
  final double toleranceMin;
  final double toleranceMax;
  final Function(double, double) onChanged;

  @override
  State<ToleranceSlider> createState() => _ToleranceSliderState();
}

class _ToleranceSliderState extends State<ToleranceSlider> {
  TextEditingController toleranceMinController = TextEditingController();
  TextEditingController toleranceMaxController = TextEditingController();

  double toleranceMin = 0;
  double toleranceMax = 0;

  @override
  void initState() {
    toleranceMinController.text =
        toleranceMinInSteps(widget.toleranceMin).toString();
    toleranceMaxController.text =
        toleranceMaxInSteps(widget.toleranceMax).toString();

    super.initState();
  }

  void runOnChangeEnd() {
    if (isValidToleranceMin(toleranceMinController.text) &&
        isValidToleranceMax(toleranceMaxController.text)) {
      widget.onChanged(double.parse(toleranceMinController.text),
          double.parse(toleranceMaxController.text));
    }
  }

  bool isValidToleranceMin(String value) {
    return double.tryParse(value) != null &&
        double.tryParse(value)! <= widget.maxValue &&
        double.tryParse(value)! >= widget.minValue &&
        double.tryParse(value)! <= widget.toleranceMax;
  }

  bool isValidToleranceMax(String value) {
    return double.tryParse(value) != null &&
        double.tryParse(value)! <= widget.maxValue &&
        double.tryParse(value)! >= widget.minValue &&
        double.tryParse(value)! >= widget.toleranceMin;
  }

  double toleranceMinInSteps(double value) {
    return calculateValuesForParameter(widget.parameter).reduce((closest,
            current) =>
        (current - value).abs() < (closest - value).abs() ? current : closest);
  }

  double toleranceMaxInSteps(double value) {
    return calculateValuesForParameter(widget.parameter).reduce((closest,
            current) =>
        (current - value).abs() < (closest - value).abs() ? current : closest);
  }

  @override
  Widget build(BuildContext context) {
    final double clampedToleranceMin =
        widget.toleranceMin.clamp(widget.minValue, widget.maxValue);
    final double clampedToleranceMax =
        widget.toleranceMax.clamp(widget.minValue, widget.maxValue);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.minValue.toString(), style: kDateTimeTextStyle),
              Text(
                '${clampedToleranceMin == clampedToleranceMax ? "Target" : "Tolerance"}: ${clampedToleranceMin.toStringAsFixed(2)}${clampedToleranceMin != clampedToleranceMax ? " - ${clampedToleranceMax.toStringAsFixed(2)}" : ""}${widget.parameter.unit}',
                style: kHeading2TextStyle,
              ),
              Text(widget.maxValue.toString(), style: kDateTimeTextStyle),
            ],
          ),
        ),
        Gap(10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 10,
            thumbColor: Colors.white,
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            disabledThumbColor: Colors.transparent,
            showValueIndicator: ShowValueIndicator.onDrag,
            overlayShape: SliderComponentShape.noOverlay,
            rangeTrackShape: _GradientRangeSliderTrackShape(
              minValue: widget.minValue,
              maxValue: widget.maxValue,
              toleranceMin: widget.toleranceMin,
              toleranceMax: widget.toleranceMax,
              context: context,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: RangeSlider(
              min: widget.minValue,
              max: widget.maxValue,
              values: RangeValues(clampedToleranceMin, clampedToleranceMax),
              onChanged: (values) => setState(() {
                toleranceMinController.text =
                    toleranceMinInSteps(values.start).toString();
                toleranceMaxController.text =
                    toleranceMaxInSteps(values.end).toString();
                widget.onChanged(double.parse(toleranceMinController.text),
                    double.parse(toleranceMaxController.text));
              }),
            ),
          ),
        ),
        Gap(20),
        Row(
          children: [
            Expanded(
              child: TextInput(
                validator: (value) {
                  if (!isValidToleranceMin(value)) {
                    return "Invalid value";
                  }

                  return null;
                },
                keyboardType: TextInputType.number,
                controller: toleranceMinController,
                label: Text("Min"),
                onChanged: (_) => runOnChangeEnd(),
                // onEditingComplete: runOnChangeEnd,
              ),
            ),
            Expanded(
              child: TextInput(
                validator: (value) {
                  if (!isValidToleranceMax(value)) {
                    return "Invalid value";
                  }

                  return null;
                },
                keyboardType: TextInputType.number,
                controller: toleranceMaxController,
                onChanged: (_) => runOnChangeEnd(),
                // onEditingComplete: runOnChangeEnd,
                label: Text("Max"),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _GradientRangeSliderTrackShape extends RangeSliderTrackShape {
  final double minValue;
  final double maxValue;
  final double toleranceMin;
  final double toleranceMax;
  final BuildContext context;

  _GradientRangeSliderTrackShape({
    required this.minValue,
    required this.maxValue,
    required this.toleranceMin,
    required this.toleranceMax,
    required this.context,
  });

  @override
  void paint(
    PaintingContext paddingContext,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackWidth = parentBox.size.width;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;

    // Calculate the start and end of the gradient based on the original tolerance values
    final double gradientStart =
        (toleranceMin - minValue) / (maxValue - minValue);
    final double gradientEnd =
        (toleranceMax - minValue) / (maxValue - minValue);

    final Rect trackRect =
        Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [
          isDarkMode
              ? Colors.transparent
              : const Color.fromARGB(0, 255, 255, 255),
          Colors.red,
          Colors.amber,
          Colors.green,
          Colors.green,
          Colors.amber,
          Colors.red,
          isDarkMode
              ? Colors.transparent
              : const Color.fromARGB(0, 255, 255, 255),
        ],
        stops: [
          0.0,
          gradientStart,
          gradientStart + (gradientEnd - gradientStart) / 8,
          gradientStart + (gradientEnd - gradientStart) / 2,
          gradientStart + (gradientEnd - gradientStart) / 2,
          gradientStart + 6 * (gradientEnd - gradientStart) / 8,
          gradientEnd,
          1.0
        ],
      ).createShader(trackRect);

    paddingContext.canvas.drawRect(trackRect, paint);
  }

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
