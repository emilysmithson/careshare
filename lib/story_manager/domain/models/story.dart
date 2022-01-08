class Story {
  late String? id;
  late String? story;
  late String? taskId;
  DateTime? dateCreated;
  late String? createdBy;
  late String? createdByDisplayName;
  List<StoryComment>? comments;


  // Map<String, StoryComment>? comments;

  Story({
    this.id,
    this.story,
    this.taskId,
    this.dateCreated,
    this.createdBy,
    this.createdByDisplayName,
    this.comments

  });

  Map<String, dynamic> toJson() {
    return {
      'story': story,
      'task_id': taskId,
      'created_by': createdBy,
      'created_by_display_name': createdByDisplayName,
      'date_created': dateCreated.toString(),
      'comments': comments?.map((comment) => comment.toJson()),

    };
  }

  factory Story.fromJson(dynamic key, dynamic value){

    final List<StoryComment> comments = <StoryComment>[];
    if (value['comments'] != null) {
      value['comments'].forEach((k, v) {
        comments.add(StoryComment.fromJson(k, v));
      });
    }

    return Story(
        story:   value['story'].toString(),
        taskId: value['task_id'],
        createdBy: value['created_by'].toString(),
        createdByDisplayName: value['created_by_display_name'] ?? '',
        dateCreated: DateTime.parse(value['date_created']),
        id: key.toString(),
        comments: comments
    );
  }

}

class StoryComment {
  final String commment;
  late String? createdBy;
  late String? createdByDisplayName;
  DateTime? dateCreated;
  late String? id;

  @override
  String toString() {
    return '''
      comment: $commment
      created by: $createdByDisplayName
      date created: $dateCreated
    ''';
  }

  StoryComment({
    required this.commment,
    this.id,
    this.createdBy,
    this.createdByDisplayName,
    this.dateCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      'commment': commment,
      'created_by': createdBy,
      'created_by_display_name': createdByDisplayName,
      'date_created': dateCreated.toString(),
    };
  }

  factory StoryComment.fromJson(String key, value) {
    StoryComment newComment = StoryComment(
      commment: value['commment'] ?? '',
      createdBy: value['created_by'] ?? '',
      createdByDisplayName: value['created_by_name'] ?? '',
      dateCreated: DateTime.parse(value['date_created']),
    );

    return newComment;
  }}