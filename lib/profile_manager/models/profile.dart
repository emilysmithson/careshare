import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';
import 'package:careshare/profile_manager/models/profile_type.dart';

class Profile {
  ProfileType type;
  String name;
  String firstName;
  String lastName;
  String displayName;
  String email;
  String phoneCountry;
  String phoneCountryCode;
  String phoneNumber;
  DateTime? dateOfBirth;
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
    this.displayName = "",
    required this.email,
    required this.phoneCountry,
    required this.phoneCountryCode,
    required this.phoneNumber,
    required this.dateOfBirth,
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

    DateTime dateOfBirth;
    if (json['date_of_birth'] != null && json['date_of_birth'] != ""){
      dateOfBirth = DateTime.parse(json['date_of_birth']);
    }
    else {
      dateOfBirth = DateTime(1900,1,1);
    }
    final createdDate = DateTime.parse(json['created_date']);

    return Profile(
      type: profileType,
      id: key,
      name: json['name'] ?? "",
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      displayName: (json['first_name']+" "+json['last_name']).toString().replaceAll("  ", " "),
      email: json['email'] ?? "",
      phoneCountry: json['phone_country'] ?? "",
      phoneCountryCode: json['phone_country_code'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      dateOfBirth: dateOfBirth,
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
      'date_of_birth': dateOfBirth.toString(),
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
    displayName: $displayName,
    email: $email,
    phoneCountry: $phoneCountry,
    phoneCountryCode: $phoneCountryCode,
    phoneNumber: $phoneNumber,
    dateOfBirth: $dateOfBirth,
    kudos: $kudos,
    photo: $photo,
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
      other.dateOfBirth == dateOfBirth &&
      other.kudos == kudos &&
      other.photo == photo &&
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
    dateOfBirth.hashCode ^
    kudos.hashCode ^
    photo.hashCode ^
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
  dateOfBirth,
  kudos,
  photo,
  photoUrl,
  tandcsAccepted,
  setupComplete,
  showInvitationsOnHomePage,
  showOtherCaregroupsOnHomePage,
  messagingToken,
}


class Avatar {
  final String avatar;
  final String url;

  const Avatar(this.avatar, this.url);

  static const Avatar avatar1 = Avatar('avatar1','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar1.jpg?alt=media&token=c32eb0ff-82d7-4a3a-912c-6c75b7dae4fa');
  static const Avatar avatar2 = Avatar('avatar2','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar2.jpg?alt=media&token=ebdb9b47-0cde-4a02-b5b0-cf616b32a1af');
  static const Avatar avatar3 = Avatar('avatar3','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar3.jpg?alt=media&token=a9c08b74-bbed-4867-a512-5cff58a5bb93');
  static const Avatar avatar4 = Avatar('avatar4','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar4.jpg?alt=media&token=7847decd-74b9-49f1-9e5d-3146460ec168');
  static const Avatar avatar5 = Avatar('avatar5','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar5.jpg?alt=media&token=38d3f7df-b40d-44ca-96a6-5027793c1bec');
  static const Avatar avatar6 = Avatar('avatar6','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar6.jpg?alt=media&token=706ec60a-46f7-49f3-ac4d-5e9ba36bc910');
  static const Avatar avatar7 = Avatar('avatar7','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar7.jpg?alt=media&token=27b3b2dd-1e28-43be-adf9-d6f130b2e5a8');
  static const Avatar avatar8 = Avatar('avatar8','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar8.jpg?alt=media&token=57e5c45e-5657-4888-8f74-e9b762be6abd');
  static const Avatar avatar9 = Avatar('avatar9','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar9.jpg?alt=media&token=9f3d2db6-2080-4084-b555-33fd364d7346');
  static const Avatar avatar10 = Avatar('avatar10','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar10.jpg?alt=media&token=b6f409c9-c336-4834-bcd5-39a7ac64f28b');
  static const Avatar avatar11 = Avatar('avatar11','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar11.jpg?alt=media&token=f85e9190-2bfc-4939-b81f-b0e21cc85be5');
  static const Avatar avatar12 = Avatar('avatar12','https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/avatars%2Favatar12.jpg?alt=media&token=15377884-c583-4f52-8f29-031d52b27d35');



  static List<Avatar> avatarList = [
    avatar1,
    avatar2,
    avatar3,
    avatar4,
    avatar5,
    avatar6,
    avatar7,
    avatar8,
    avatar9,
    avatar10,
    avatar11,
    avatar12,
  ];
}
