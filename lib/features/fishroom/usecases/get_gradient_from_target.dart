import 'package:fishroom/features/tank_reading/models/parameter.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/models/tank.dart';
import '../../../core/usecases/is_dark_mode.dart';
import '../../tank_reading/usecases/calculate_values_for_parameter.dart';
import 'get_middle_value.dart';

Gradient generateGradient(
    BuildContext context, Target target, Parameter parameter) {
  Color firstColor =
      isDarkMode(context) ? darkmodeBackgroundColor : lightmodeBackgroundColor;
  Color secondColor = isDarkMode(context) ? kSecondaryColor : kPrimaryColor;

  LinearGradient baseGradient = LinearGradient(
      colors: [firstColor, secondColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  if (parameter.value == null) {
    secondColor = Colors.red;

    return LinearGradient(
        colors: [firstColor, secondColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight);
  }

  if (parameter.value! <= target.minValue) {
    secondColor = Colors.red;

    return LinearGradient(
        colors: [firstColor, secondColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight);
  }

  if (parameter.value! >= target.maxValue) {
    secondColor = Colors.red;

    return LinearGradient(
        colors: [firstColor, secondColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight);
  }

  if (parameter.value! > target.minValue &&
      parameter.value! < target.maxValue) {
    secondColor = Colors.green;

    int stepsFromTarget = 0;

    List<double> values = calculateValuesForParameter(parameter);
    int indexOfValue =
        values.indexWhere((element) => element == parameter.value);
    int indexOfTarget =
        values.indexWhere((element) => element == getMiddleValue(target));

    stepsFromTarget = (indexOfValue - indexOfTarget).abs();

    if (stepsFromTarget > 2) {
      secondColor = Colors.amber;
    }

    return LinearGradient(
        colors: [firstColor, secondColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight);
  }

  return baseGradient;
}
