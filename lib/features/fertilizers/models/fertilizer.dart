class Fertilizer {
  final String id;
  final String name;
  final String dosage;
  final String perVolume;

  Fertilizer({
    required this.id,
    required this.name,
    required this.dosage,
    required this.perVolume,
  });

  factory Fertilizer.fromJson(Map<String, dynamic> json) {
    return Fertilizer(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      perVolume: json['perVolume'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'perVolume': perVolume,
    };
  }
}
