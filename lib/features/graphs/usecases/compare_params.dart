import '../../tank_reading/models/parameter.dart';

bool compareParams(Parameter param1, Parameter param2) {
  return param1.name == param2.name &&
      param1.shortName == param2.shortName &&
      param1.unit == param2.unit;
}
