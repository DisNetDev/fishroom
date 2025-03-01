import 'package:fishroom/features/tank_reading/models/dosage.dart';
import 'package:fishroom/features/tank_reading/models/parameter.dart';

class TankReading {
  final String id;
  final TankReadingType type;
  final String tankId;
  final String ownerId;
  final String createdAt;
  List<Parameter> parameters;
  String? note;
  String? imageUrl;
  int? waterChangePercentage;
  List<Dosage> dosages = [];

  TankReading({
    required this.id,
    required this.type,
    required this.ownerId,
    required this.tankId,
    required this.createdAt,
    List<Parameter>? parameters,
    this.note,
    this.imageUrl,
    this.waterChangePercentage,
    List<Dosage>? dosages,
  })  : parameters = parameters ?? [],
        dosages = dosages ?? [];

  factory TankReading.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = TankReadingType.values.firstWhere(
      (e) => e.label == typeStr,
      orElse: () => TankReadingType.note,
    );

    return TankReading(
        id: json['id'] as String,
        type: type,
        tankId: json['tank_id'] as String,
        ownerId: json['owner_id'] as String,
        createdAt: json['created_at'] as String,
        note: json['note'] as String?,
        imageUrl: json['image_url'] != null ? (json['image_url']) : null,
        parameters: (json['data'] as List<dynamic>?)
                ?.map((param) => Parameter.fromJson(param))
                .toList() ??
            [],
        waterChangePercentage: json["water_change_percentage"] as int?,
        dosages: (json['dosages'] as List<dynamic>?)
                ?.map((dosage) => Dosage.fromJson(dosage))
                .toList() ??
            []);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.label,
      'owner_id': ownerId,
      'tank_id': tankId,
      'created_at': createdAt,
      'note': note,
      'image_url': imageUrl,
      'data': parameters.map((param) => param.toJson()).toList(),
      'water_change_percentage': waterChangePercentage,
      "dosages": dosages.map((dosage) => dosage.toJson()).toList(),
    };
  }

  TankReading copyWith({
    String? id,
    TankReadingType? type,
    String? tankId,
    String? ownerId,
    String? createdAt,
    String? note,
    String? imageUrl,
    List<Parameter>? parameters,
    int? waterChangePercentage,
    List<Dosage>? dosages,
  }) {
    return TankReading(
        id: id ?? this.id,
        type: type ?? this.type,
        tankId: tankId ?? this.tankId,
        ownerId: ownerId ?? this.ownerId,
        createdAt: createdAt ?? this.createdAt,
        note: note ?? this.note,
        imageUrl: imageUrl ?? this.imageUrl,
        parameters: parameters ?? this.parameters,
        waterChangePercentage:
            waterChangePercentage ?? this.waterChangePercentage,
        dosages: dosages ?? this.dosages);
  }
}

enum TankReadingType {
  measurement,
  note,
  waterChange,
  trim,
  feed,
  fertilize,
  glassScrape,
  clean,
}

extension TankReadingTypeExtension on TankReadingType {
  String get label {
    switch (this) {
      case TankReadingType.measurement:
        return "Measurement";
      case TankReadingType.note:
        return "Note";
      case TankReadingType.waterChange:
        return "Water Change";
      case TankReadingType.trim:
        return "Trim";
      case TankReadingType.feed:
        return "Feed";
      case TankReadingType.fertilize:
        return "Fertilize";
      case TankReadingType.glassScrape:
        return "Glass Scrape";
      case TankReadingType.clean:
        return "General Clean";
    }
  }
}
