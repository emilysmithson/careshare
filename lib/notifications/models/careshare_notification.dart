class CareshareNotification {
  final String id;
  final String caregroupId;
  final String title;
  final String routeName;
  final String subtitle;
  final String senderId;
  final DateTime dateTime;
  final bool isRead;
  final String arguments;

  CareshareNotification({
    required this.id,
    required this.caregroupId,
    required this.title,
    required this.routeName,
    required this.subtitle,
    required this.dateTime,
    required this.senderId,
    required this.isRead,
    required this.arguments,
  });

  factory CareshareNotification.fromJson(Map<String, dynamic> json) {
    return CareshareNotification(
      id: json['id'],
      caregroupId: json['caregroup'] ?? "",
      title: json['title'],
      routeName: json['route'],
      subtitle: json['subtitle'],
      senderId: json['sender_id'],
      dateTime: DateTime.parse(json['date_time']),
      isRead: json['is_read'],
      arguments: json['arguments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caregroup': caregroupId,
      'title': title,
      'route': routeName,
      'subtitle': subtitle,
      'sender_id': senderId,
      'date_time': dateTime.toString(),
      'is_read': isRead,
      'arguments': arguments,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CareshareNotification &&
        other.id == id &&
        other.caregroupId == caregroupId &&
        other.title == title &&
        other.routeName == routeName &&
        other.subtitle == subtitle &&
        other.senderId == senderId &&
        other.dateTime == dateTime &&
        other.isRead == isRead &&
        other.arguments == arguments;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        caregroupId.hashCode ^
        title.hashCode ^
        routeName.hashCode ^
        subtitle.hashCode ^
        senderId.hashCode ^
        dateTime.hashCode ^
        isRead.hashCode ^
        arguments.hashCode;
  }
}
