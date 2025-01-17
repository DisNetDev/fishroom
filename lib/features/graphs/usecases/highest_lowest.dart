import '../../../core/models/tank_reading.dart';
import '../../tank_reading/models/parameter.dart';

double getHighestValue(List<TankReading> data, Parameter filterParam) {
  List<double> values = [];
  List<Parameter> params = [];
  for (TankReading reading in data) {
    params.add(reading.parameters.firstWhere(
        (param) => param.id == filterParam.id,
        orElse: () => Parameter(id: '', value: 0)));
  }
  for (Parameter param in params) {
    if (param.value != null) {
      values.add(param.value!);
    }
  }

  return values.reduce((value, element) => value > element ? value : element);
}

double getLowestValue(List<TankReading> data, Parameter filterParam) {
  List<double> values = [];
  List<Parameter> params = [];
  for (TankReading reading in data) {
    params.add(reading.parameters.firstWhere(
        (param) => param.id == filterParam.id,
        orElse: () => Parameter(id: '', value: 0)));
  }
  for (Parameter param in params) {
    if (param.value != null) {
      values.add(param.value!);
    }
  }

  double lowest =
      values.reduce((value, element) => value < element ? value : element);

  return lowest;
}

double getGraphWidth(List<TankReading> data, Parameter filterParam) {
  List<double> values = [];
  List<Parameter> params = [];
  for (TankReading reading in data) {
    params.add(reading.parameters.firstWhere(
        (param) => param.id == filterParam.id,
        orElse: () => Parameter(id: '', value: 0)));
  }
  for (Parameter param in params) {
    if (param.value != null) {
      values.add(param.value!);
    }
  }

  double length = values.length.toDouble();
  if (length == 1) {
    return 2;
  }
  if (length > 30) {
    return 30;
  }

  return length - 1;
}

double getGraphMinX(List<TankReading> data, Parameter filterParam) {
  List<double> values = [];
  List<Parameter> params = [];
  for (TankReading reading in data) {
    params.add(reading.parameters.firstWhere(
        (param) => param.id == filterParam.id,
        orElse: () => Parameter(id: '', value: 0)));
  }
  for (Parameter param in params) {
    if (param.value != null) {
      values.add(param.value!);
    }
  }

  double length = values.length.toDouble();
  if (length <= 30) {
    return 0;
  }
  return length - 30;
}
