import 'package:image_picker/image_picker.dart';

class Tank {
  String id;
  String? name;
  String? type;
  String? size;
  String? measurementUnit;
  XFile? image;

  Tank(
      {required this.id,
      this.name,
      this.type,
      this.size,
      this.measurementUnit,
      this.image});
}
