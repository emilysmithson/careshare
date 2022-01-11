
class Profile {
  late String? firstName;
  late String? lastName;
  late String? displayName;
  late String? authId;
  late String? id;
  late String? taskTypes;
  DateTime? dateCreated;
  late String? createdBy;
  late String? careeIn;
  late String? carerIn;

  Profile({
    this.id,
    this.firstName,
    this.lastName,
    this.displayName,
    this.authId,
    this.taskTypes,
    this.dateCreated,
    this.createdBy,
    this.careeIn,
    this.carerIn,
  });

  Map<String, dynamic> toJson() {

    // List<String> careeInList = [];
    // careeIn!.forEach((Caregroup c) {
    //   careeInList.add(c.id!);
    // });
    // List<String> carerInList = [];
    // carerIn!.forEach((Caregroup c) {
    //   carerInList.add(c.id!);
    // });

    return {
      'first_name': firstName,
      'last_name': lastName,
      'display_name': displayName,
      'auth_id': authId,
      'task_types': taskTypes,
      'created_by': createdBy,
      'date_created': dateCreated.toString(),
      // 'caree_in': careeInList.join(','),
      // 'carer_in': carerInList.join(','),
      'caree_in': careeIn.toString(),
      'carer_in': carerIn.toString(),
    };
  }

  factory Profile.fromJson(dynamic key, dynamic value) {
    final authId  = value['auth_id'];
    final firstName =   value['first_name'];
    final lastName =   value['last_name'];
    final displayName =   value['display_name'];
    final createdBy = value['created_by'].toString();
    final dateCreated = DateTime.parse(value['date_created']);
    final taskTypes = value['task_types'];
    final id = key.toString();
    final String? careeIn = value['caree_in']; //(value['caree_in'] == null) ? value['caree_in'] : null;
    final String? carerIn = value['carer_in']; //(value['carer_in'] == null) ? value['carer_in'] : null;

    return Profile(
      authId: authId,
      firstName: firstName,
      lastName: lastName,
      displayName: displayName,
      createdBy: createdBy,
      dateCreated: dateCreated,
      taskTypes: taskTypes,
      id: id,
      careeIn: careeIn,
      carerIn: carerIn
    );

  }


}
