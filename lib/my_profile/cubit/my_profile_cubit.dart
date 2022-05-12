// import 'dart:io';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// import '../models/profile.dart';

// part 'my_profile_state.dart';

// class MyProfileCubit extends Cubit<MyProfileState> {
//   MyProfileCubit() : super(MyProfileInitial());
//   late Profile myProfile;

//   Future fetchMyProfile(String id) async {
//     try {
//       emit(MyProfileLoading());
//       DatabaseReference reference =
//           FirebaseDatabase.instance.ref('profiles/$id');
//       final response = reference.onValue;

//       response.listen((event) async {
//         if (event.snapshot.value == null) {
//           emit(const MyProfileError(message: "profile is null"));
//           return;
//         } else {
//           final data = event.snapshot.value;
//           myProfile = Profile.fromJson(data);

//           emit(MyProfileLoaded(
//             myProfile: myProfile,
//           ));
//         }
//       });
//     } catch (error) {
//       emit(
//         MyProfileError(
//           message: error.toString(),
//         ),
//       );
//     }
//   }

//   createProfile({
//     File? photo,
//     String? name,
//     String? firstName,
//     String? lastName,
//     String? email,
//     required String id,
//   }) async {
//     if (photo == null || name == null || email == null) {
//       emit(MyProfileError(
//           message:
//               'One of the fields for the profile is null:\nphoto: $photo, \nname: $name\nlastName: $lastName\nemail: $email'));
//       return;
//     }
//     emit(MyProfileLoading());

//     final ref = FirebaseStorage.instance
//         .ref()
//         .child('profile_photos')
//         .child(id + '.jpg');

//     await ref.putFile(photo);
//     final url = await ref.getDownloadURL();

//     myProfile = Profile(
//       id: id,
//       name: name,
//       firstName: firstName ?? "",
//       lastName: lastName ?? "",
//       email: email,
//       kudos: 0,
//       photo: url,
//       createdDate: DateTime.now(),
//       carerInCaregroups: [],
//       tandcsAccepted: false,
//       showInvitationsOnHomePage: true,
//       showOtherCaregropusOnHomePage: true,
//     );

//     try {
//       DatabaseReference reference = FirebaseDatabase.instance.ref('profiles');
//       reference.child(myProfile.id).set(myProfile.toJson());
//     } catch (error) {
//       emit(MyProfileError(message: error.toString()));
//     }
//     fetchMyProfile(id);
//   }
// }
