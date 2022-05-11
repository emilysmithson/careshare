import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';

class Profile {
  String name;
  String firstName;
  String lastName;
  String email;
  final String id;
  String photo;
  DateTime createdDate;
  int kudos;
  bool tandcsAccepted;
  bool showInvitationsOnHomePage;
  bool showOtherCaregropusOnHomePage;
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
    required this.tandcsAccepted,
    required this.showInvitationsOnHomePage,
    required this.showOtherCaregropusOnHomePage,
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
      tandcsAccepted: json['tandcs_accepted'] ?? false,
      showInvitationsOnHomePage: json['show_invitations_on_homepage'] ?? false,
      showOtherCaregropusOnHomePage:
          json['show_other_caregroups_on_homepage'] ?? false,
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
      'tandcs_accepted': tandcsAccepted,
      'show_invitations_on_homepage': showInvitationsOnHomePage,
      'show_other_caregroups_on_homepage': showOtherCaregropusOnHomePage,
      'carer_in': carerInCaregroups
          ?.map((carerInCaregroups) => carerInCaregroups.toJson())
          .toList(),
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
    tandcsAccepted: $tandcsAccepted,
    showInvitationsOnHomePage: $showInvitationsOnHomePage,
    showOtherCaregropusOnHomePage: $showOtherCaregropusOnHomePage,
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
  tandcsAccepted,
  showInvitationsOnHomePage,
  showOtherCaregropusOnHomePage,
}
