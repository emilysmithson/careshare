class CareCategory {
  String name;

  final String? id;

  CareCategory({
    required this.id,
    required this.name,
  });

  factory CareCategory.fromJson(dynamic json) {
    return CareCategory(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return '''
    id: $id,
    name: $name,
    

    ''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CareCategory && other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
