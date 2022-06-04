import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';
import 'package:careshare/profile_manager/models/profile_type.dart';

class Profile {
  ProfileType type;
  String name;
  String firstName;
  String lastName;
  String email;
  String phoneCountry;
  String phoneCountryCode;
  String phoneNumber;
  final String id;
  String photo;
  DateTime createdDate;
  int kudos;
  bool tandcsAccepted;
  bool setupComplete;
  bool showInvitationsOnHomePage;
  bool showOtherCaregroupsOnHomePage;
  String messagingToken;
  List<RoleInCaregroup> carerInCaregroups = [];

  Profile({
    required this.id,
    required this.type,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneCountry,
    required this.phoneCountryCode,
    required this.phoneNumber,
    required this.photo,
    required this.createdDate,
    required this.kudos,
    required this.tandcsAccepted,
    required this.setupComplete,
    required this.showInvitationsOnHomePage,
    required this.showOtherCaregroupsOnHomePage,
    required this.messagingToken,
    required this.carerInCaregroups,
  });

  factory Profile.fromJson(dynamic key, dynamic json) {
    final profileType = ProfileType.profileTypeList.firstWhere((element) => element.type == json['type']);

    final List<RoleInCaregroup> carerInCaregroups = [];

    if (json['carer_in'] != null) {
      json['carer_in'].forEach((k, v) {
        carerInCaregroups.add(RoleInCaregroup.fromJson(k,v));
      });
    }
    final createdDate = DateTime.parse(json['created_date']);

    return Profile(
      type: profileType,
      id: key,
      name: json['name'] ?? "",
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      email: json['email'] ?? "",
      phoneCountry: json['phone_country'] ?? "",
      phoneCountryCode: json['phone_country_code'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      photo: json['photo'] ?? "",
      kudos: json['kudos'] ?? 0,
      createdDate: createdDate,
      tandcsAccepted: json['tandcs_accepted'] ?? false,
      setupComplete: json['setup_complete'] ?? false,
      showInvitationsOnHomePage: json['show_invitations_on_homepage'] ?? false,
      showOtherCaregroupsOnHomePage: json['show_other_caregroups_on_homepage'] ?? false,
      messagingToken: json['messaging_token'] ?? "",
      carerInCaregroups: carerInCaregroups,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.type,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_country': phoneCountry,
      'phone_country_code': phoneCountryCode,
      'phone_number': phoneNumber,
      'kudos': kudos,
      'photo': photo,
      'created_date': createdDate.toString(),
      'tandcs_accepted': tandcsAccepted,
      'setup_complete': setupComplete,
      'show_invitations_on_homepage': showInvitationsOnHomePage,
      'show_other_caregroups_on_homepage': showOtherCaregroupsOnHomePage,
      'messaging_token': messagingToken,
      'carer_in': carerInCaregroups.map((carerInCaregroups) => carerInCaregroups.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return '''
    id: $id,
    type: $type,
    name: $name,
    firstName: $firstName,
    lastName: $lastName,
    email: $email,
    phoneCountry: $phoneCountry,
    phoneCountryCode: $phoneCountryCode,
    phoneNumber: $phoneNumber,
    kudos: $kudos,
    createdDate: $createdDate,
    tandcsAccepted: $tandcsAccepted,
    setupComplete: $setupComplete,
    showInvitationsOnHomePage: $showInvitationsOnHomePage,
    showOtherCaregroupsOnHomePage: $showOtherCaregroupsOnHomePage,
    messagingToken: $messagingToken,
    carer_in: $carerInCaregroups,
    ''';
  }


@override
bool operator ==(Object other) {
  if (identical(this, other)) return true;

  return other is Profile &&
      other.id == id &&
      other.type == type &&
      other.name == name &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.phoneCountry == phoneCountry &&
      other.phoneCountryCode == phoneCountryCode &&
      other.phoneNumber == phoneNumber &&
      other.kudos == kudos &&
      other.createdDate == createdDate &&
      other.tandcsAccepted == tandcsAccepted &&
      other.setupComplete == setupComplete &&
      other.showInvitationsOnHomePage == showInvitationsOnHomePage &&
      other.showOtherCaregroupsOnHomePage == showOtherCaregroupsOnHomePage &&
      other.messagingToken == messagingToken &&
      other.carerInCaregroups == carerInCaregroups;
}

@override
int get hashCode =>
    id.hashCode ^
    type.hashCode ^
    name.hashCode ^
    firstName.hashCode ^
    lastName.hashCode ^
    email.hashCode ^
    phoneCountry.hashCode ^
    phoneCountryCode.hashCode ^
    phoneNumber.hashCode ^
    kudos.hashCode ^
    createdDate.hashCode ^
    tandcsAccepted.hashCode ^
    setupComplete.hashCode ^
    showInvitationsOnHomePage.hashCode ^
    showOtherCaregroupsOnHomePage.hashCode ^
    messagingToken.hashCode ^
    carerInCaregroups.hashCode;

}

enum ProfileField {
  name,
  type,
  firstName,
  lastName,
  email,
  phoneCountry,
  phoneCountryCode,
  phoneNumber,
  kudos,
  photo,
  tandcsAccepted,
  setupComplete,
  showInvitationsOnHomePage,
  showOtherCaregroupsOnHomePage,
  messagingToken,
}
