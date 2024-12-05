import 'package:fishroom/features/tank_reading/models/parameter.dart';
import 'dart:math' show pow;

List<double> calculateValuesForParameter(Parameter parameter) {
  List<double> values = [];

  if (parameter.min == null) parameter = parameter.copyWith(min: 0);
  if (parameter.max == null) parameter = parameter.copyWith(max: 50);
  if (parameter.step == null || parameter.step == 0) {
    parameter = parameter.copyWith(step: 1);
  }

  // Calculate number of decimal places in step to maintain precision
  int decimalPlaces = parameter.step.toString().split('.').length > 1
      ? parameter.step.toString().split('.')[1].length
      : 0;

  // Use a multiplier to avoid floating point arithmetic errors
  int multiplier = pow(10, decimalPlaces).toInt();
  int start = (parameter.min! * multiplier).round();
  int end = (parameter.max! * multiplier).round();
  int step = (parameter.step! * multiplier).round();

  for (int i = start; i <= end; i += step) {
    values.add(i / multiplier);
  }

  if (values.length > 500) {
    values = values.sublist(0, 500);
  }

  return values;
}
