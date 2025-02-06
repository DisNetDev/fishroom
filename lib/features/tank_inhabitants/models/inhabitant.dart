import 'dart:math';

class Inhabitant {
  String id;
  String? petName;
  String? commonName;
  String scientificName;
  String? imageUrl;
  int? count;

  Inhabitant({
    required this.id,
    this.petName,
    this.commonName,
    required this.scientificName,
    this.imageUrl,
    this.count,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pet_name': petName,
      'common_name': commonName,
      'scientific_name': scientificName,
      'image_url': imageUrl,
      'count': count,
    };
  }

  factory Inhabitant.fromJson(Map<String, dynamic> json) {
    try {
      return Inhabitant(
        id: json['id'],
        petName: json['pet_name'] ?? "",
        commonName: json['common_name'] ?? "",
        scientificName: json['scientific_name'] ?? "No scientific name",
        imageUrl: json['image_url'] ?? "",
        count: json['count'] ?? 0,
      );
    } catch (e) {
      rethrow;
    }
  }

  Inhabitant copyWith({
    String? id,
    String? petName,
    String? commonName,
    String? scientificName,
    String? imageUrl,
    int? count,
  }) {
    return Inhabitant(
      id: id ?? this.id,
      petName: petName ?? this.petName,
      commonName: commonName ?? this.commonName,
      scientificName: scientificName ?? this.scientificName,
      imageUrl: imageUrl ?? this.imageUrl,
      count: count ?? this.count,
    );
  }

  static Inhabitant getPlaceholder() {
    return Inhabitant(
      id: 'placeholder_id_${DateTime.now().millisecondsSinceEpoch}',
      petName: 'Pet_${_generateRandomString(5, 10)}',
      commonName: 'CommonName_${_generateRandomString(3, 8)}',
      scientificName: 'ScientificName_${_generateRandomString(8, 15)}',
      imageUrl: 'https://example.com/image_${_generateRandomString(3, 5)}.png',
      count: Random().nextInt(10) + 1,
    );
  }

  static String _generateRandomString(int minLength, int maxLength) {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final length = Random().nextInt(maxLength - minLength + 1) + minLength;

    return List.generate(
            length, (index) => characters[Random().nextInt(characters.length)])
        .join();
  }
}
