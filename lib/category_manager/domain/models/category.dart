
class Category {
  late String? name;
  late String? details;
  late String? id;
  DateTime? dateCreated;
  late String? createdBy;

  Category({
    this.id,
    this.name,
    this.details,
    this.dateCreated,
    this.createdBy,

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'details': details,
      'created_by': createdBy,
      'date_created': dateCreated.toString(),
    };
  }

  Category.fromJson(dynamic key, dynamic value):
        name =   value['name'],
        details =   value['details'].toString(),
        createdBy = value['created_by'].toString(),
        dateCreated = DateTime.parse(value['date_created']),
      id = key.toString()
  ;

}
