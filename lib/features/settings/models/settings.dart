import '../../tank_reading/models/parameter.dart';

class Settings {
  final List<Parameter> parameters;
  final bool compactTankTile;

  Settings({
    required this.parameters,
    this.compactTankTile = false,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      parameters: (json['parameters'] as List<dynamic>)
          .map<Parameter>((dynamic json) => Parameter.fromJson(json))
          .toList(),
      compactTankTile: json['compactTankTile'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parameters': parameters.map((e) => e.toJson()).toList(),
      'compactTankTile': compactTankTile,
    };
  }

  Settings copyWith({
    List<Parameter>? parameters,
    bool? compactTankTile,
  }) {
    return Settings(
      parameters: parameters ?? this.parameters,
      compactTankTile: compactTankTile ?? this.compactTankTile,
    );
  }
}
