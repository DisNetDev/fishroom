class TankReading {
  final String id;
  final TankReadingType type;
  final String tankId;
  final String createdAt;
  final String note;

  const TankReading({
    required this.id,
    required this.type,
    required this.tankId,
    required this.createdAt,
    required this.note,
  });

  factory TankReading.fromJson(Map<String, dynamic> json) {
    return TankReading(
      id: json['id'] as String,
      type: json['type'] == "Note"
          ? TankReadingType.note
          : TankReadingType.measurement,
      tankId: json['tank_id'] as String,
      createdAt: json['created_at'] as String,
      note: json['note'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.label,
      'tank_id': tankId,
      'created_at': createdAt,
      'note': note,
    };
  }
}

enum TankReadingType {
  measurement,
  note,
}

extension TankReadingTypeExtension on TankReadingType {
  String get label {
    switch (this) {
      case TankReadingType.measurement:
        return "Measurement";
      case TankReadingType.note:
        return "Note";
    }
  }
}
