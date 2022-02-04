class Kudos {
  final String id;
  final DateTime dateTime;

  Kudos({
    required this.id,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_time': dateTime.toString(),
    };
  }

  factory Kudos.fromJson(value) {
    Kudos newKudos = Kudos(
      dateTime: DateTime.parse(value['date_time']),
      id: value['id'],
    );

    return newKudos;
  }
  @override
  String toString() {
    return '''id: $id
              dateTime: $dateTime''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Kudos && other.id == id && other.dateTime == dateTime;
  }

  @override
  int get hashCode => id.hashCode ^ dateTime.hashCode;
}
