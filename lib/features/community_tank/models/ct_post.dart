class CTPost {
  final String id;
  final String title;
  final String content;
  final String authorID;
  final String authorName;
  final String createdAt;
  final String? updatedAt;
  final List<String> images;
  final int upVotes;
  final int downVotes;
  final bool? isUpvoted;
  CTPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorID,
    required this.authorName,
    required this.createdAt,
    this.updatedAt,
    required this.images,
    this.upVotes = 0,
    this.downVotes = 0,
    this.isUpvoted,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author_id': authorID,
      'author_name': authorName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'images': images,
      'up_votes': upVotes,
      'down_votes': downVotes,
    };
  }

  factory CTPost.fromJson(Map<String, dynamic> json) {
    return CTPost(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorID: json['author_id'] as String,
      authorName: json['author_name'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      images: List<String>.from(json['images'] as List),
    );
  }

  CTPost copyWith({
    String? title,
    String? content,
    String? authorID,
    String? authorName,
    String? createdAt,
    String? updatedAt,
    List<String>? images,
    int? upVotes,
    int? downVotes,
    bool? isUpvoted,
  }) {
    return CTPost(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorID: authorID ?? this.authorID,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      isUpvoted: isUpvoted ?? this.isUpvoted,
    );
  }
}
