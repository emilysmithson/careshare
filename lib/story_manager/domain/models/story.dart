class Story {
  late String? name;
  late String? story;
  late String? id;
  DateTime? dateCreated;
  late String? createdBy;
  late String? createdByDisplayName;

  // Map<String, StoryComment>? comments;

  Story({
    this.id,
    this.name,
    this.story,
    this.dateCreated,
    this.createdBy,
    this.createdByDisplayName,

    // this.comments

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'story': story,
      'created_by': createdBy,
      'created_by_display_name': createdByDisplayName,
      'date_created': dateCreated.toString(),
      //'comments': comments?.map((comment) => comment.toJson()).toList(),

    };
  }

  Story.fromJson(dynamic key, dynamic value):
        name =   value['name'].toString(),
        story =   value['story'].toString(),
        createdBy = value['created_by'].toString(),
        createdByDisplayName = value['created_by_display_name'] ?? '',
        dateCreated = DateTime.parse(value['date_created']),
      id = key.toString()
  ;

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

  factory StoryComment.fromJson(dynamic value){
    StoryComment newComment = StoryComment(
      commment: value['commment'] ?? '',
      createdBy: value['created_by'] ?? '',
      createdByDisplayName: value['created_by_name'] ?? '',
      dateCreated: DateTime.parse(value['date_created']),
    );

    return newComment;
  }}