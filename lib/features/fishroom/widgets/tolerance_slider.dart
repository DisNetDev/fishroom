import 'package:flutter/material.dart';

import '../../../core/constants.dart';

class ToleranceSlider extends StatelessWidget {
  const ToleranceSlider(
      {super.key,
      required this.minValue,
      required this.maxValue,
      required this.toleranceMin,
      required this.toleranceMax});

  final double minValue;
  final double maxValue;
  final double toleranceMin;
  final double toleranceMax;

  @override
  Widget build(BuildContext context) {
    // Clamp the tolerance values within the min and max range
    final double clampedToleranceMin = toleranceMin.clamp(minValue, maxValue);
    final double clampedToleranceMax = toleranceMax.clamp(minValue, maxValue);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(minValue.toString(), style: kDateTimeTextStyle),
              Text(
                '${clampedToleranceMin == clampedToleranceMax ? "Target" : "Tolerance"}: ${clampedToleranceMin.toStringAsFixed(2)}${clampedToleranceMin != clampedToleranceMax ? " - ${clampedToleranceMax.toStringAsFixed(2)}" : ""}',
                style: kHeading2TextStyle,
              ),
              Text(maxValue.toString(), style: kDateTimeTextStyle),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 10,
            thumbColor: Colors.white,
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            disabledThumbColor: Colors.transparent,
            showValueIndicator: ShowValueIndicator.always,
            overlayShape: SliderComponentShape.noOverlay,
            rangeTrackShape: _GradientRangeSliderTrackShape(
              minValue: minValue,
              maxValue: maxValue,
              toleranceMin: toleranceMin,
              toleranceMax: toleranceMax,
            ),
            rangeThumbShape: _SquareThumbShape(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: RangeSlider(
              min: minValue,
              max: maxValue,
              values: RangeValues(clampedToleranceMin, clampedToleranceMax),
              onChanged: (values) => {},
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientRangeSliderTrackShape extends RangeSliderTrackShape {
  final double minValue;
  final double maxValue;
  final double toleranceMin;
  final double toleranceMax;

  _GradientRangeSliderTrackShape({
    required this.minValue,
    required this.maxValue,
    required this.toleranceMin,
    required this.toleranceMax,
  });

  @override
  void paint(
    PaintingContext context,
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

    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.red,
          Colors.amber,
          Colors.green,
          Colors.green,
          Colors.amber,
          Colors.red,
          Colors.transparent,
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

    context.canvas.drawRect(trackRect, paint);
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

class _SquareThumbShape extends RangeSliderThumbShape {
  static const double _thumbSize = 12.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size(_thumbSize, _thumbSize);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    bool isPressed = false,
    required SliderThemeData sliderTheme,
    TextDirection textDirection = TextDirection.ltr,
    Thumb thumb = Thumb.start,
  }) {
    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    final Rect thumbRect = Rect.fromCenter(
      center: center,
      width: 2,
      height: _thumbSize,
    );

    context.canvas.drawRect(thumbRect, paint);
  }
}
