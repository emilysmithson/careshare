

class Profile {
  late String? firstName;
  late String? lastName;
  late String? authId;
  late String? id;
  late String? taskTypes;
  DateTime? dateCreated;
  late String? createdBy;

  Profile({
    this.id,
    this.firstName,
    this.lastName,
    this.authId,
    this.taskTypes,
    this.dateCreated,
    this.createdBy,

  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'auth_id': authId,
      'task_types': taskTypes,
      'created_by': createdBy,
      'date_created': dateCreated.toString(),
    };
  }

  Profile.fromJson(dynamic key, dynamic value):
        authId  = value['auth_id'].toString(),
        firstName =   value['first_name'].toString(),
        lastName =   value['last_name'].toString(),
        createdBy = value['created_by'].toString(),
        dateCreated = DateTime.parse(value['date_created']),
        taskTypes = value['task_types'].toString(),
        id = key.toString()
  ;

}
