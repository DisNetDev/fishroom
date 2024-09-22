class TankReading {
  final String id;
  final TankReadingType type;
  final String tankId;
  final String dateTime;
  final String note;

  const TankReading({
    required this.id,
    required this.type,
    required this.tankId,
    required this.dateTime,
    required this.note,
  });
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

