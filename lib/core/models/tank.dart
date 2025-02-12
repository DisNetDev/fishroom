import '../../features/tank_inhabitants/models/inhabitant.dart';

class Tank {
  String id;
  String? name;
  String? createdAt;
  String? ownerId;
  String? type;
  int? size;
  String? measurementUnit;
  String? imageLocalPath;
  String? imageUrl;
  List<Inhabitant> inhabitants;
  List<Target> targets;

  Tank(
      {required this.id,
      this.name,
      this.createdAt,
      this.ownerId,
      this.type,
      this.size,
      this.measurementUnit,
      this.imageLocalPath,
      this.imageUrl,
      this.targets = const [],
      this.inhabitants = const []});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'owner_id': ownerId,
      'tank_type': type,
      'tank_size': size,
      'tank_measurement': measurementUnit,
      'image_url': imageUrl,
      'image_local_path': imageLocalPath,
      'targets': targets.map((e) => e.toJson()).toList(),
      'inhabitants': inhabitants.map((e) => e.toJson()).toList(),
    };
  }

  factory Tank.fromJson(Map<String, dynamic> json) {
    return Tank(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      ownerId: json['owner_id'],
      type: json['tank_type'],
      size: json['tank_size'],
      measurementUnit: json['tank_measurement'],
      imageUrl: json['image_url'],
      imageLocalPath: json['image_local_path'],
      targets: (json['targets'] as List<dynamic>)
          .map((e) => Target.fromJson(e as Map<String, dynamic>))
          .toList(),
      inhabitants: (json['inhabitants'] as List<dynamic>)
          .map((e) => Inhabitant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Tank copyWith({
    String? id,
    String? name,
    String? createdAt,
    String? ownerId,
    String? type,
    int? size,
    String? measurementUnit,
    String? imageLocalPath,
    String? imageUrl,
    List<Inhabitant>? inhabitants,
  }) {
    return Tank(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        ownerId: ownerId ?? this.ownerId,
        type: type ?? this.type,
        size: size ?? this.size,
        measurementUnit: measurementUnit ?? this.measurementUnit,
        imageLocalPath: imageLocalPath ?? this.imageLocalPath,
        imageUrl: imageUrl ?? this.imageUrl,
        inhabitants: inhabitants ?? this.inhabitants);
  }
}

class Target {
  String paramID;
  double value;

  Target({required this.paramID, required this.value});

  Map<String, dynamic> toJson() {
    return {
      'param_id': paramID,
      'value': value,
    };
  }

  factory Target.fromJson(Map<String, dynamic> json) {
    return Target(paramID: json['param_id'], value: json['value']);
  }
}
