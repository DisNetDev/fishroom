class FishUser {
  FishUser({required this.uuid, required this.email, required this.premium});
  final String uuid;
  final String email;
  bool premium;

  factory FishUser.fromJson(Map<String, dynamic> json) {
    return FishUser(
      uuid: json['uuid'],
      email: json['email'],
      premium: json['premium'],
    );
  }
}
