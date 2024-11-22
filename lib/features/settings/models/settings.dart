import '../../tank_reading/models/parameter.dart';

class Settings {
  final List<Parameter> parameters;

  Settings({
    required this.parameters,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      parameters: (json['parameters'] as List<dynamic>)
          .map<Parameter>((dynamic json) => Parameter.fromJson(json))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parameters': parameters.map((e) => e.toJson()).toList(),
    };
  }
}
