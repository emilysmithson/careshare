class Comment {
  final String comment;
  final String createdBy;
  final String createdByDisplayName;
  final DateTime commentCreatedDate;
  final String id;

  @override
  String toString() {
    return '''
      comment: $comment
      created by: $createdByDisplayName
      date created: $commentCreatedDate
    ''';
  }

  Comment({
    required this.comment,
    required this.id,
    required this.createdBy,
    required this.createdByDisplayName,
    required this.commentCreatedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'created_by': createdBy,
      'created_by_display_name': createdByDisplayName,
      'created_date': commentCreatedDate.toString(),
      'id': id,
    };
  }

  factory Comment.fromJson(value) {
    Comment newComment = Comment(
      comment: value['comment'] ?? '',
      createdBy: value['created_by'] ?? '',
      createdByDisplayName: value['created_by_display_name'] ?? '',
      commentCreatedDate: (DateTime.tryParse(value['created_date']) != null) ? DateTime.parse(value['created_date']) : DateTime.now(),
      id: value['id'],
    );

    return newComment;
  }
}
