class Profile {
  late String? name;
  final String? authId;
  late String? id;

  late String? createdBy;

  Profile({
    this.name,
    this.authId,
    this.id,

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'auth_id': authId,
      'created_by': createdBy,


    };
  }

  Profile.fromJson(dynamic key, dynamic value):
        authId  = value['auth_id'].toString(),
        name =   value['name'].toString(),
        createdBy = value['created_by'].toString(),
        id = key.toString()
  ;
}
