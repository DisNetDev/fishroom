import 'package:fishroom/features/tank_reading/models/parameter.dart';

List<double> calculateValuesForParameter(Parameter parameter) {
  List<double> values = [];

  for (double i = parameter.min!; i <= parameter.max!; i += parameter.step!) {
    values.add(i);
  }

  return values;
}
