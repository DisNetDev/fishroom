class FishUser {
  FishUser({required this.uuid, required this.email, required this.premium});
  final String uuid;
  final String email;
  bool premium;

  factory FishUser.fromJson(Map<String, dynamic> json) {
    return FishUser(
      uuid: json['id'] ?? "",
      email: json['email'] ?? "",
      premium: json['premium'] ?? false,
    );
  }

  // New toJson method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': uuid,
      'email': email,
      'premium': premium,
    };
  }
}
