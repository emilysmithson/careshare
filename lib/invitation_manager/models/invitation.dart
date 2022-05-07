class Invitation {
  final String id;
  String caregroupId;
  String email;
  String? message;
  String invitedById;
  DateTime invitedDate;

  Invitation({
    required this.id,
    required this.caregroupId,
    required this.email,
    this.message,
    required this.invitedById,
    required this.invitedDate,
  });

  factory Invitation.fromJson(dynamic json) {
    final invitedDate = DateTime.parse(json['invited_date']);

    return Invitation(
      id: json['id'],
      caregroupId: json['caregroup_id'],
      email: json['email'] ?? "",
      message: json['message'] ?? "",
      invitedById: json['invited_by_id'],
      invitedDate: invitedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caregroup_id': caregroupId,
      'email': email,
      'message': message,
      'invited_by_id': invitedById,
      'invited_date': invitedDate.toString(),
    };
  }

  @override
  String toString() {
    return '''
    id: $id,
    caregroupId: $caregroupId
    email: $email,
    message: $message,
    invitedById: $invitedById,
    invitedDate: $invitedDate,
    ''';
  }
}

enum InvitationField {
  caregroupId,
  email,
  message,
  invitedById,
  invitedDate,
}
