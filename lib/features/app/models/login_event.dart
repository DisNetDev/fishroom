class LoginEvent {
  final String uuid;
  final String createdAt;

  LoginEvent({required this.uuid, required this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': uuid,
      'created_at': createdAt,
    };
  }
}
