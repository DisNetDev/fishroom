import '../../../core/models/tank.dart';
import '../../tank_reading/models/parameter.dart';

String getToleranceWording(Target target, Parameter parameter) {
  String toleranceWording = "";

  toleranceWording =
      "${target.minValue == target.maxValue ? "Target" : "Target"}: ${target.minValue}${(target.maxValue != target.minValue) ? " - ${target.maxValue}" : ""}";

  return toleranceWording;
}
