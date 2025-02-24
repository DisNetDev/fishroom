import '../../fertilizers/models/fertilizer.dart';
import '../../tank_reading/models/parameter.dart';

class Settings {
  final List<Parameter> parameters;
  final List<Fertilizer> fertilizers;
  final bool compactTankTile;

  Settings({
    required this.parameters,
    required this.fertilizers,
    this.compactTankTile = false,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      parameters: json['parameters'] != null
          ? (json['parameters'] as List<dynamic>)
              .map<Parameter>((dynamic json) => Parameter.fromJson(json))
              .toList()
          : [],
      fertilizers: json['fertilizers'] != null
          ? (json['fertilizers'] as List<dynamic>)
              .map<Fertilizer>((dynamic json) => Fertilizer.fromJson(json))
              .toList()
          : [],
      compactTankTile: json['compactTankTile'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parameters': parameters.map((e) => e.toJson()).toList(),
      'fertilizers': fertilizers.map((e) => e.toJson()).toList(),
      'compactTankTile': compactTankTile,
    };
  }

  Settings copyWith({
    List<Parameter>? parameters,
    List<Fertilizer>? fertilizers,
    bool? compactTankTile,
  }) {
    return Settings(
      parameters: parameters ?? this.parameters,
      fertilizers: fertilizers ?? this.fertilizers,
      compactTankTile: compactTankTile ?? this.compactTankTile,
    );
  }
}
