class CTComment {
  final String id;
  final String postId;
  final String content;
  final String createdAt;
  final String authorId;
  final String authorName;

  CTComment({
    required this.id,
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
  });

  factory CTComment.fromJson(Map<String, dynamic> json) {
    return CTComment(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'content': content,
      'created_at': createdAt,
      'author_id': authorId,
      'author_name': authorName,
    };
  }
}
