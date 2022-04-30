class Comment {
  final String commment;
  final String createdBy;
  final String createdByDisplayName;
  final DateTime commentCreatedDate;
  final String id;

  @override
  String toString() {
    return '''
      comment: $commment
      created by: $createdByDisplayName
      date created: $commentCreatedDate
    ''';
  }

  Comment({
    required this.commment,
    required this.id,
    required this.createdBy,
    required this.createdByDisplayName,
    required this.commentCreatedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'commment': commment,
      'created_by': createdBy,
      'created_by_display_name': createdByDisplayName,
      'created_date': commentCreatedDate.toString(),
      'id': id,
    };
  }

  factory Comment.fromJson(value) {
    Comment newComment = Comment(
      commment: value['commment'] ?? '',
      createdBy: value['created_by'] ?? '',
      createdByDisplayName: value['created_by_display_name'] ?? '',
      commentCreatedDate: DateTime.parse(value['created_date']),
      id: value['id'],
    );

    return newComment;
  }
}
