import '../../../core/models/database_tables.dart';

class FishUser {
  FishUser({required this.uuid, required this.email, required this.premium});
  final String uuid;
  final String email;
  bool premium;
  

  factory FishUser.fromJson(Map<String, dynamic> json) {
    return FishUser(
      uuid: json[Table.users.id],
      email: json[Table.users.email],
      premium: json[Table.users.premium] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      Table.users.id: uuid,
      Table.users.email: email,
      Table.users.premium: premium,
    };
  }

  FishUser copyWith({
    String? uuid,
    String? email,
    bool? premium,
  }) {
    return FishUser(
      uuid: uuid ?? this.uuid,
      email: email ?? this.email,
      premium: premium ?? this.premium,
    );
  }
}
