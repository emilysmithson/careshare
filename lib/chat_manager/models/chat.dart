import 'package:careshare/chat_manager/models/chat_type.dart';

class Chat {

  final String id;
  String channelId;
  String fromProfileId;
  DateTime timeStamp;
  String content;
  ChatType type;



  Chat({
    required this.id,
    required this.channelId,
    required this.fromProfileId,
    required this.timeStamp,
    required this.content,
    required this.type,
  });


  Map<String, dynamic> toJson() {

    return {
      'id': id,
      'channel': channelId,
      'from': fromProfileId,
      'time_stamp': timeStamp.toString(),
      'content': content,
      'type': type.type,
    };
  }

  factory Chat.fromJson(dynamic key, dynamic value) {

     return Chat(
       id: key,
        channelId: value['channel'],
        fromProfileId: value['from'],
        timeStamp: DateTime.parse(value['time_stamp']),
        content: value['content'],
        type: ChatType.ChatTypeList
          .firstWhere((element) => element.type == value['type']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chat &&
        other.id == id &&
        other.channelId == channelId &&
        other.fromProfileId == fromProfileId &&
        other.timeStamp == timeStamp &&
        other.content == content &&
        other.type == type
    ;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    channelId.hashCode ^
    fromProfileId.hashCode ^
    timeStamp.hashCode ^
    content.hashCode ^
    type.hashCode
    ;
  }
}

