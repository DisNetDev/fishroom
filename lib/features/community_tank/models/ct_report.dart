// ignore_for_file: public_member_api_docs, sort_constructors_first

class CTReport {
  CTReport({
    required this.id,
    required this.createdAt,
    required this.reporterId,
    this.postId,
    this.commentId,
    this.reason,
  });
  final String id;
  final String createdAt;
  final String reporterId;
  final String? postId;
  final String? commentId;
  final String? reason;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdAt,
      'reporter_id': reporterId,
      'post_id': postId,
      'comment_id': commentId,
      'reason': reason,
    };
  }

  factory CTReport.fromMap(Map<String, dynamic> map) {
    return CTReport(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      reporterId: map['reporter_id'] as String,
      postId: map['post_id'] != null ? map['post_id'] as String : null,
      commentId: map['comment_id'] != null ? map['comment_id'] as String : null,
      reason: map['reason'] != null ? map['reason'] as String : null,
    );
  }

  CTReport copyWith({
    String? id,
    String? createdAt,
    String? reporterId,
    String? postId,
    String? commentId,
    String? reason,
  }) {
    return CTReport(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      reporterId: reporterId ?? this.reporterId,
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
      reason: reason ?? this.reason,
    );
  }
}
