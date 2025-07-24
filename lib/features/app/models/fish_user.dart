import '../../../core/models/database_tables.dart';

class FishUser {
  FishUser({
    required this.uuid,
    required this.email,
    required this.premium,
    required this.username,
    this.activeSubscription,
    this.nextProCheck,
    required this.welcomeEmailSent,
  });
  final String uuid;
  final String email;
  bool premium;
  String? username;
  String? activeSubscription;
  String? nextProCheck;
  bool welcomeEmailSent;

  factory FishUser.fromJson(Map<String, dynamic> json) {
    return FishUser(
      username: json[SupabaseTable.users.username],
      uuid: json[SupabaseTable.users.id],
      email: json[SupabaseTable.users.email],
      premium: json[SupabaseTable.users.premium] ?? false,
      welcomeEmailSent: json["welcome_email_sent"],
      nextProCheck: json["next_pro_check"],
      activeSubscription: json["active_subscription"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      SupabaseTable.users.id: uuid,
      SupabaseTable.users.email: email,
      SupabaseTable.users.premium: premium,
      SupabaseTable.users.username: username,
      "welcome_email_sent": welcomeEmailSent,
      "next_pro_check": nextProCheck,
      "active_subscription": activeSubscription,
    };
  }

  FishUser copyWith({
    String? uuid,
    String? email,
    bool? premium,
    String? username,
    bool? welcomeEmailSent,
    String? nextProCheck,
    String? activeSubscription,
  }) {
    return FishUser(
      uuid: uuid ?? this.uuid,
      email: email ?? this.email,
      premium: premium ?? this.premium,
      username: username ?? this.username,
      welcomeEmailSent: welcomeEmailSent ?? this.welcomeEmailSent,
      nextProCheck: nextProCheck ?? this.nextProCheck,
      activeSubscription: activeSubscription ?? this.activeSubscription,
    );
  }
}
