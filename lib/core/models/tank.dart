import 'package:image_picker/image_picker.dart';

class Tank {
  final String? id;
  final String? name;
  final String? type;
  final String? size;
  final String? measurementUnit;
  final XFile? image;

  const Tank(
      {this.id,
      this.name,
      this.type,
      this.size,
      this.measurementUnit,
      this.image});
}
