import '../../tank_reading/models/parameter.dart';

bool areParametersEdited(List<Parameter> parameters, List<Parameter> defaults) {
  if (parameters.length != defaults.length) return true;

  for (int i = 0; i < parameters.length; i++) {
    if (parameters[i].description != defaults[i].description) return true;
    if (parameters[i].max != defaults[i].max) return true;
    if (parameters[i].min != defaults[i].min) return true;
    if (parameters[i].name != defaults[i].name) return true;
    if (parameters[i].shortName != defaults[i].shortName) return true;
    if (parameters[i].step != defaults[i].step) return true;
    if (parameters[i].unit != defaults[i].unit) return true;
  }

  return false;
}
