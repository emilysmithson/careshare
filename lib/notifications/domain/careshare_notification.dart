class CareshareNotification {
  final String title;
  final String routeName;
  final String subtitle;
  final String userId;
  final DateTime dateTime;
  final bool isRead;
  final Map<String, dynamic> arguments;

  CareshareNotification({
    required this.title,
    required this.routeName,
    required this.subtitle,
    required this.dateTime,
    required this.userId,
    required this.isRead,
    required this.arguments,
  });

  factory CareshareNotification.fromJson(Map<String, dynamic> json) {
    return CareshareNotification(
      title: json['title'],
      routeName: json['route'],
      subtitle: json['subtitle'],
      userId: json['user_id'],
      dateTime: json['date_time'],
      isRead: json['is_read'],
      arguments: json['arguments'],
    );
  }
}
