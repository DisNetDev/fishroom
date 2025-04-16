import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

DropdownMenuThemeData dropdownThemeDataLight = DropdownMenuThemeData(
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: _enabledBorder,
    focusedBorder: _focusedBorderLight,
    errorBorder: _errorGradient,
    focusedErrorBorder: _errorGradient,
    border: GradientOutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      gradient: LinearGradient(
        colors: [
          Colors.grey.shade300,
          Colors.grey,
          Colors.grey.shade300,
        ],
      ),
    ),
  ),
);

DropdownMenuThemeData dropdownThemeDataDark = DropdownMenuThemeData(
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: _enabledBorder,
    focusedBorder: _focusedBorderDark,
    errorBorder: _errorGradient,
    focusedErrorBorder: _errorGradient,
    border: _enabledBorder,
  ),
);

GradientOutlineInputBorder get _focusedBorderLight =>
    GradientOutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(colors: [
          kPrimaryColor,
          Colors.grey,
          kPrimaryColor,
        ]));

GradientOutlineInputBorder get _focusedBorderDark => GradientOutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    gradient: LinearGradient(colors: [
      kSecondaryColor,
      Colors.grey,
      kSecondaryColor,
    ]));

GradientOutlineInputBorder get _enabledBorder => GradientOutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    gradient: LinearGradient(colors: [
      Colors.grey.shade300,
      Colors.grey,
      Colors.grey.shade300,
    ]));

GradientOutlineInputBorder get _errorGradient => GradientOutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    gradient: LinearGradient(colors: [
      Colors.red,
      Colors.grey,
      Colors.red,
    ]));
