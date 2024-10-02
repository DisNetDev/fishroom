import 'package:image_picker/image_picker.dart';

class Tank {
  String id;
  String? name;
  String? createdAt;
  String? ownerId;
  String? type;
  int? size;
  String? measurementUnit;
  XFile? image;
  String? imageUrl;

  Tank(
      {required this.id,
      this.name,
      this.createdAt,
      this.ownerId,
      this.type,
      this.size,
      this.measurementUnit,
      this.image,
      this.imageUrl});

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
    );
  }
}
