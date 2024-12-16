import 'package:uuid/uuid.dart';

class Parameter {
  final String id;
  final String? name;
  final String? shortName;
  final String? description;
  final String? unit;
  final double? max;
  final double? min;
  final double? step;
  double? value;

  Parameter({
    required this.id,
    this.shortName,
    this.name,
    this.description,
    this.unit,
    this.max,
    this.min,
    this.step,
    this.value,
  });

  factory Parameter.from(Parameter param, double? value) {
    param = param.copyWith(value: value);

    return Parameter(
      id: param.id,
      shortName: param.shortName,
      name: param.name,
      description: param.description,
      unit: param.unit,
      max: param.max,
      min: param.min,
      step: param.step,
      value: param.value,
    );
  }

  factory Parameter.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Parameter(id: Uuid().v4());

    return Parameter(
      // Start of Selection
      id: json['id'] as String? ?? Uuid().v4(),
      shortName: json['shortName'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      unit: json['unit'] as String?,
      max: json['max'] != null ? (json['max'] as num).toDouble() : null,
      min: json['min'] != null ? (json['min'] as num).toDouble() : null,
      step: json['step'] != null ? (json['step'] as num).toDouble() : null,
      value: json['value'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shortName': shortName,
      'name': name,
      'description': description,
      'unit': unit,
      'max': max,
      'min': min,
      'step': step,
      'value': value,
    };
  }

  Parameter copyWith({
    String? name,
    String? shortName,
    String? description,
    String? unit,
    double? max,
    double? min,
    double? step,
    double? value,
  }) {
    return Parameter(
      id: id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      max: max ?? this.max,
      min: min ?? this.min,
      step: step ?? this.step,
      value: value ?? this.value,
    );
  }
}
