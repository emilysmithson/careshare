// ignore_for_file: invalid_use_of_protected_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home_page/presenter/home_page.dart';
import '../../widgets/snackbar.dart';

class AuthenticationController {
  final formKey = GlobalKey<FormState>();
  final emailAdressController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;
  bool resetSent = false;
  bool forgottenPassword = false;
  final register = ValueNotifier<bool>(true);

  void toggleShowPassword() {
    hidePassword = !hidePassword;

    // ignore: invalid_use_of_visible_for_testing_member
    register.notifyListeners();
  }

  void toggleForgotPassword() {
    forgottenPassword = true;
    // ignore: invalid_use_of_visible_for_testing_member
    register.notifyListeners();
  }

  Future authenticate(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (register.value) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailAdressController.text,
              password: passwordController.text);

          return Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            return showErrorMessage(
                context: context,
                message: 'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            showErrorMessage(
                context: context,
                message: 'The account already exists for that email.');
          }
        }
      }
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailAdressController.text,
            password: passwordController.text);

        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showErrorMessage(
              context: context, message: 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showErrorMessage(
              context: context,
              message: 'Wrong password provided for that user.');
        }
      }
    }
  }

  void sendPasswordReminder() {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailAdressController.text);
    resetSent = true;
    forgottenPassword = false;
    register.value = false;
  }
}
