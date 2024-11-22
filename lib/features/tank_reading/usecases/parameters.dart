class Parameter {
  final String? name;
  final String? shortName;
  final String? unit;
  final double? max;
  final double? min;
  final double? step;

  Parameter({
    this.shortName,
    this.name,
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
      'unit': unit,
      'max': max,
      'min': min,
      'step': step,
    };
  }
}

List<Parameter> readingParameters = [
  Parameter(shortName: "PH", name: "ph", unit: "Acidity", min: 4, max: 14),
  Parameter(
      shortName: "AMM", name: "Total Ammonia", min: 0, max: 10, unit: "ppm"),
  Parameter(shortName: "NO2", name: "Nitrite", min: 0, max: 10, unit: "ppm"),
  Parameter(shortName: "NO3", name: "Nitrate", min: 0, max: 150, unit: "ppm"),
  Parameter(
      shortName: "GH", name: "General Hardness", min: 0, max: 30, unit: "dGH"),
  Parameter(
      shortName: "KH",
      name: "Carbonate Hardness",
      min: 0,
      max: 30,
      unit: "dKH"),
  Parameter(
      shortName: "TDS",
      name: "Total Dissolved Solids",
      unit: "",
      max: 500,
      min: 0)
];
