class Parameter {
  final String? name;
  final String? shortName;
  final String? description;
  final String? unit;
  final double? max;
  final double? min;
  final double? step;

  Parameter({
    this.shortName,
    this.name,
    this.description,
    this.unit,
    this.max,
    this.min,
    this.step,
  });

  factory Parameter.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Parameter();

    return Parameter(
      shortName: json['shortName'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      unit: json['unit'] as String?,
      max: json['max'] != null ? (json['max'] as num).toDouble() : null,
      min: json['min'] != null ? (json['min'] as num).toDouble() : null,
      step: json['step'] != null ? (json['step'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shortName': shortName,
      'name': name,
      'description': description,
      'unit': unit,
      'max': max,
      'min': min,
      'step': step,
    };
  }
}
