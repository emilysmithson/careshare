class Comment {
  final String commment;
  final String createdBy;
  final String createdByDisplayName;
  final DateTime dateCreated;
  final String id;

  @override
  String toString() {
    return '''
      comment: $commment
      created by: $createdByDisplayName
      date created: $dateCreated
    ''';
  }

  Comment({
    required this.commment,
    required this.id,
    required this.createdBy,
    required this.createdByDisplayName,
    required this.dateCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      'commment': commment,
      'created_by': createdBy,
      'created_by_display_name': createdByDisplayName,
      'date_created': dateCreated.toString(),
      'id': id,
    };
  }

  factory Comment.fromJson(value) {
    Comment newComment = Comment(
      commment: value['commment'] ?? '',
      createdBy: value['created_by'] ?? '',
      createdByDisplayName: value['created_by_display_name'] ?? '',
      dateCreated: DateTime.parse(value['date_created']),
      id: value['id'],
    );

    return newComment;
  }
}
