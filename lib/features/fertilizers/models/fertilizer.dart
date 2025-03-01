class Fertilizer {
  final String id;
  final String name;
  final double dosage;
  final String dosageUnit;
  final double perVolume;
  final String perVolumeUnit;

  Fertilizer({
    required this.id,
    required this.name,
    required this.dosage,
    required this.dosageUnit,
    required this.perVolume,
    required this.perVolumeUnit,
  });

  factory Fertilizer.fromJson(Map<String, dynamic> json) {
    return Fertilizer(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'] ?? 0,
      dosageUnit: json['dosageUnit'],
      perVolume: json['perVolume'] ?? 0,
      perVolumeUnit: json['perVolumeUnit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'dosageUnit': dosageUnit,
      'perVolume': perVolume,
      'perVolumeUnit': perVolumeUnit,
    };
  }

  Fertilizer copyWith({
    String? name,
    double? dosage,
    String? dosageUnit,
    double? perVolume,
    String? perVolumeUnit,
  }) {
    return Fertilizer(
        id: id,
        name: name ?? this.name,
        dosage: dosage ?? this.dosage,
        dosageUnit: dosageUnit ?? this.dosageUnit,
        perVolume: perVolume ?? this.perVolume,
        perVolumeUnit: perVolumeUnit ?? this.perVolumeUnit);
  }
}
