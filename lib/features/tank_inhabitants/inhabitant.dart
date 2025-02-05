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
    return Inhabitant(
      id: json['id'],
      petName: json['pet_name'],
      commonName: json['common_name'],
      scientificName: json['scientific_name'],
      imageUrl: json['image_url'],
      count: json['count'],
    );
  }
}
