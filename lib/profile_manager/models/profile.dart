import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';

class Profile {
  String name;
  String firstName;
  String lastName;
  String email;
  final String? id;
  String photo;
  DateTime createdDate;

  int kudos;

  List<RoleInCaregroup>? carerInCaregroups = [];

  Profile({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.photo,
    required this.createdDate,
    required this.kudos,
    required this.carerInCaregroups,

  });

  factory Profile.fromJson(dynamic json) {

    final List<RoleInCaregroup> carerInCaregroups = [];

    if (json['carer_in'] != null) {
      json['carer_in'].forEach((k, v) {
        carerInCaregroups.add(RoleInCaregroup.fromJson(v));
      });
    }
    final createdDate = DateTime.parse(json['created_date']);

    return Profile(
      id: json['id'],
      name: json['name'] ?? "",
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      email: json['email'] ?? "",
      photo: json['photo'] ?? "",
      kudos: json['kudos'] ?? 0,
      createdDate: createdDate,

      carerInCaregroups: carerInCaregroups,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'kudos': kudos,
      'photo': photo,
      'created_date': createdDate.toString(),
      'carer_in': carerInCaregroups?.map((carerInCaregroups) => carerInCaregroups.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return '''
    id: $id,
    name: $name,
    firstName: $firstName,
    lastName: $lastName,
    email: $email,
    kudos: $kudos,
    createdDate: $createdDate,
    carer_in: $carerInCaregroups,
    ''';
  }
}

enum ProfileField {
  name,
  firstName,
  lastName,
  email,
  kudos,
  photo,
}
