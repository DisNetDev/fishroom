import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../constants.dart';

DropdownMenuThemeData dropdownThemeData = DropdownMenuThemeData(
  inputDecorationTheme: InputDecorationTheme(
      border: GradientOutlineInputBorder(
          gradient: LinearGradient(colors: [kPrimaryColor, kSecondaryColor]))),
);
