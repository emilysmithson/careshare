class Profile {
  late String? name;
  final String? authId;
  late String? id;
  DateTime? dateCreated;
  late String? createdBy;
  late String? acceptedBy;
  DateTime? profileAcceptedForDate;

  Profile({
    this.name,
    this.authId,
    this.id,
    this.createdBy,
    this.dateCreated,
    this.acceptedBy,
    this.profileAcceptedForDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'auth_id': authId,
      'created_by': createdBy,
      'date_created': dateCreated.toString(),
      'accepted_by': acceptedBy,
      'accepted_for_date': profileAcceptedForDate.toString(),
    };
  }

  Profile.fromJson(dynamic key, dynamic value):
        name = value['name'] ?? '',
        createdBy = value['created_by'] ?? '',
        id = key,
        dateCreated = DateTime.parse(value['date_created']),

        authId = value['auth_id'] as String,
        profileAcceptedForDate = DateTime.tryParse(value['accepted_for_date']),
        acceptedBy = value['accepted_by'] ?? ''
  ;
}
