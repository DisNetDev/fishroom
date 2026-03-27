import 'package:flutter/material.dart';

SliderThemeData sliderTheme = SliderThemeData(
    trackHeight: 10.0,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
    thumbColor: Colors.white,
    showValueIndicator: ShowValueIndicator.onDrag,
    overlayShape: SliderComponentShape.noOverlay);
