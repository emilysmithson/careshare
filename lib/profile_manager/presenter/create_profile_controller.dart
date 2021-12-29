import 'package:flutter/material.dart';

import '../domain/models/profile.dart';
import '../domain/usecases/all_profile_usecases.dart';
import 'profile_entered_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:careshare/global.dart';

class CreateProfileController {
  final formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController taskTypesController;

  initialiseControllers() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    taskTypesController = TextEditingController();
  }

  createProfile({
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      final Profile profile = Profile();
      profile.firstName = firstNameController.text;
      profile.lastName = lastNameController.text;
      profile.dateCreated = DateTime.now();
      profile.taskTypes = taskTypesController.text;
      profile.authId = FirebaseAuth.instance.currentUser?.uid;

      final response = await AllProfileUseCases.createProfile(profile);
      response.fold((l) => null, (r) => profile.id = r);
      myProfileId = profile.id;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileEnteredScreen(profile: profile),
        ),
      );
    }
  }
}
