class Parameter {
  final List<double> values;
  final String name;
  final String shortName;
  final String unit;
  final double max;
  final double min;

  Parameter({
    required this.shortName,
    required this.name,
    required this.values,
    required this.unit,
    required this.max,
    required this.min,
  });
}

List<Parameter> readingParameters = [
  Parameter(
      shortName: "PH",
      name: "ph",
      values: _generateDoublesForPh(),
      unit: "Acidity",
      min: 4,
      max: 14),
  Parameter(
      shortName: "TA",
      name: "Total Ammonia",
      values: _generateDoublesForAmmonia(),
      min: 0,
      max: 10,
      unit: "ppm"),
  Parameter(
      shortName: "NO2",
      name: "Nitrite",
      min: 0,
      max: 10,
      values: _generateDoublesForNitrite(),
      unit: "ppm"),
  Parameter(
      shortName: "NO3",
      name: "Nitrate",
      min: 0,
      max: 150,
      values: _generateDoublesForNitrate(),
      unit: "ppm"),
  Parameter(
      shortName: "GH",
      name: "General Hardness",
      values: _generateDegrees(),
      min: 0,
      max: 30,
      unit: "dGH"),
  Parameter(
      shortName: "KH",
      name: "Carbonate Hardness",
      values: _generateDegrees(),
      min: 0,
      max: 30,
      unit: "dKH"),
  Parameter(
      shortName: "TDS",
      name: "Total Dissolved Solids",
      values: _generateTDS(),
      unit: "",
      max: 500,
      min: 0)
];

//Generate ph Values
List<double> _generateDoublesForPh() {
  List<double> doubles = [];
  for (double i = 4.0; i <= 10.0; i += 0.1) {
    doubles
        .add(double.parse(i.toStringAsFixed(1))); // Ensures one decimal place
  }
  return doubles;
}

List<double> _generateDoublesForAmmonia() {
  List<double> doubles = [];
  for (double i = 0.0; i <= 10.0; i += 0.25) {
    // Updated increment and range
    doubles
        .add(double.parse(i.toStringAsFixed(2))); // Ensures two decimal places
  }
  return doubles;
}

List<double> _generateDoublesForNitrite() {
  List<double> doubles = [];
  for (double i = 0.0; i <= 10.0; i += 0.25) {
    // Updated increment and range
    doubles
        .add(double.parse(i.toStringAsFixed(2))); // Ensures two decimal places
  }
  return doubles;
}

List<double> _generateDoublesForNitrate() {
  List<double> doubles = [];
  for (double i = 0.0; i <= 150.0; i += 5.0) {
    // Updated increment and range
    doubles
        .add(double.parse(i.toStringAsFixed(2))); // Ensures two decimal places
  }
  return doubles;
}

List<double> _generateDegrees() {
  List<double> doubles = [];
  for (double i = 0.0; i <= 30.0; i += 1) {
    // Updated increment and range
    doubles
        .add(double.parse(i.toStringAsFixed(2))); // Ensures two decimal places
  }
  return doubles;
}

List<double> _generateTDS() {
  List<double> doubles = [];
  for (double i = 0.0; i <= 500.0; i += 1) {
    // Updated increment and range
    doubles
        .add(double.parse(i.toStringAsFixed(2))); // Ensures two decimal places
  }
  return doubles;
}
