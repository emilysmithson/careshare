import '../../../caregroup_manager/domain/models/caregroup.dart';


class Profile {
  late String? firstName;
  late String? lastName;
  late String? authId;
  late String? id;
  late String? taskTypes;
  DateTime? dateCreated;
  late String? createdBy;
  late String? careeIn;
  late String? carerIn;
  late List<Caregroup>? careeInCaregroups;
  late List<Caregroup>? carerInCaregroups;

  Profile({
    this.id,
    this.firstName,
    this.lastName,
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
    final authId  = value['auth_id'].toString();
    final firstName =   value['first_name'].toString();
    final lastName =   value['last_name'].toString();
    final createdBy = value['created_by'].toString();
    final dateCreated = DateTime.parse(value['date_created']);
    final taskTypes = value['task_types'].toString();
    final id = key.toString();
    final careeIn = value['caree_in'].toString();
    final carerIn = value['carer_in'].toString();

    // List<Caregroup> careeIn = [];
    // value['caree_in'].toString().split(',').forEach((String caregroupId) async {
    //   final result = await AllCaregroupUseCases.fetchACaregroup(caregroupId);
    //   result.fold((l) => null, (r) => careeIn.add(r));
    // });

    // List<Caregroup> carerIn = [];
    // value['carer_in'].toString().split(',').forEach((String caregroupId) async {
    //
    //   final result = await AllCaregroupUseCases.fetchACaregroup(caregroupId);
    //   result.fold(
    //           (l) => null,
    //           (r) => carerIn.add(r)
    //   );
    // });



    return Profile(
      authId: authId,
      firstName: firstName,
      lastName: lastName,
      createdBy: createdBy,
      dateCreated: dateCreated,
      taskTypes: taskTypes,
      id: id,
      careeIn: careeIn,
      carerIn: carerIn
    );

  }


}
