class TankReading {
  final String id;
  final TankReadingType type;
  final String tankId;
  final String ownerId;
  final String createdAt;
  String? note;
  double? ph;
  double? ta;
  double? no2;
  double? no3;
  double? gh;
  double? kh;
  String? imageUrl;

  TankReading({
    required this.id,
    required this.type,
    required this.ownerId,
    required this.tankId,
    required this.createdAt,
    this.note,
    this.ph,
    this.ta,
    this.no2,
    this.no3,
    this.gh,
    this.kh,
    this.imageUrl,
  });

  factory TankReading.fromJson(Map<String, dynamic> json) {
    return TankReading(
      id: json['id'] as String,
      type: json['type'] == "Note"
          ? TankReadingType.note
          : TankReadingType.measurement,
      tankId: json['tank_id'] as String,
      ownerId: json['owner_id'] as String,
      createdAt: json['created_at'] as String,
      note: json['note'] as String?,
      ph: json['ph'] != null ? (json['ph']).toDouble() : null,
      ta: json['ta'] != null ? (json['ta']).toDouble() : null,
      no2: json['no2'] != null ? (json['no2']).toDouble() : null,
      no3: json['no3'] != null ? (json['no3']).toDouble() : null,
      gh: json['gh'] != null ? (json['gh']).toDouble() : null,
      kh: json['kh'] != null ? (json['kh']).toDouble() : null,
      imageUrl: json['image_url'] != null ? (json['image_url']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.label,
      'owner_id': ownerId,
      'tank_id': tankId,
      'created_at': createdAt,
      'note': note,
      'ph': ph,
      'ta': ta,
      'no2': no2,
      'no3': no3,
      'gh': gh,
      'kh': kh,
      'image_url': imageUrl
    };
  }

  TankReading copyWith({
    String? id,
    TankReadingType? type,
    String? tankId,
    String? ownerId,
    String? createdAt,
    String? note,
    double? ph,
    double? ta,
    double? no2,
    double? no3,
    double? gh,
    double? kh,
    String? imageUrl,
  }) {
    return TankReading(
      id: id ?? this.id,
      type: type ?? this.type,
      tankId: tankId ?? this.tankId,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      ph: ph ?? this.ph,
      ta: ta ?? this.ta,
      no2: no2 ?? this.no2,
      no3: no3 ?? this.no3,
      gh: gh ?? this.gh,
      kh: kh ?? this.kh,
      imageUrl: imageUrl ?? this.imageUrl,
    );
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
