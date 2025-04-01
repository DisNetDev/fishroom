class CTComment {
  final String id;
  final String postId;
  final String content;
  final String createdAt;
  final String userId;
  final String username;

  CTComment({
    required this.id,
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.username,
  });

  factory CTComment.fromJson(Map<String, dynamic> json) {
    return CTComment(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'content': content,
      'created_at': createdAt,
      'user_id': userId,
      'username': username,
    };
  }
}
