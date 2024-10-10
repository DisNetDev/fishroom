class Parameter {
  final List<double> values;
  final String name;
  final String shortName;
  final String unit;

  Parameter({
    required this.shortName,
    required this.name,
    required this.values,
    required this.unit,
  });
}

List<Parameter> readingParameters = [
  Parameter(
      shortName: "ph", name: "ph", values: _generateDoublesForPh(), unit: ""),
  Parameter(
      shortName: "TA",
      name: "Total Ammonia",
      values: _generateDoublesForAmmonia(),
      unit: "ppm"),
  Parameter(
      shortName: "NO2",
      name: "Nitrite",
      values: _generateDoublesForNitrite(),
      unit: "ppm"),
  Parameter(
      shortName: "NO3",
      name: "Nitrate",
      values: _generateDoublesForNitrate(),
      unit: "ppm"),
  Parameter(
      shortName: "GH",
      name: "General Hardness",
      values: _generateDegrees(),
      unit: "dGH"),
  Parameter(
      shortName: "KH",
      name: "Carbonate Hardness",
      values: _generateDegrees(),
      unit: "dKH"),
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
  for (double i = 0.0; i <= 200.0; i += 5.0) {
    // Updated increment and range
    doubles
        .add(double.parse(i.toStringAsFixed(2))); // Ensures two decimal places
  }
  return doubles;
}

List<double> _generateDegrees() {
  List<double> doubles = [];
  for (double i = 0.0; i <= 40.0; i += 1) {
    // Updated increment and range
    doubles
        .add(double.parse(i.toStringAsFixed(2))); // Ensures two decimal places
  }
  return doubles;
}
