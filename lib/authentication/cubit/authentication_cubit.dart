import 'package:bloc/bloc.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  checkAuthentication() async {
    emit(AuthenticationLoading());
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    } catch (error) {
      emit(AuthenticationError());
    }
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(const AuthenticationRegister());
    } else {
      emit(AuthenticationLoaded(user));
    }
  }

  register({
    required String name,
    required String email,
    required String password,
    required ProfileCubit profileCubit,
  }) async {
    try {
      emit(AuthenticationLoading());
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return emit(AuthenticationRegister(
            errorMessage: 'The password provided is too weak.',
            initialEmailValue: email,
            initialNameValue: name));
      } else if (e.code == 'email-already-in-use') {
        return emit(
          AuthenticationRegister(
              errorMessage: 'The account already exists for that email.',
              initialEmailValue: email,
              initialNameValue: name),
        );
      }
      return emit(
        AuthenticationRegister(
            errorMessage: e.message.toString(),
            initialEmailValue: email,
            initialNameValue: name),
      );
    }

    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(const AuthenticationRegister());
    } else {
      profileCubit.createProfile(
        id: FirebaseAuth.instance.currentUser!.uid,
        email: email,
        name: name,
      );

      emit(AuthenticationLoaded(user));
    }
  }

  login({
    required ProfileCubit profileCubit,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return emit(AuthenticationLogin(
          errorMessage: 'User already exists for that email.',
          initialEmailValue: email,
        ));
      } else if (e.code == 'wrong-password') {
        return emit(AuthenticationLogin(
          errorMessage: 'Incorrect password',
          initialEmailValue: email,
        ));
      }
      return emit(AuthenticationLogin(
        errorMessage: e.message.toString(),
        initialEmailValue: email,
      ));
    }
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(const AuthenticationRegister());
    } else {
      emit(AuthenticationLoaded(user));
    }
  }

  resetPassword({
    required String email,
  }) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  switchToRegister({
    String? emailAddress,
  }) {
    emit(AuthenticationRegister(initialEmailValue: emailAddress));
  }

  switchToLogin({String? emailAddress}) {
    emit(AuthenticationLogin(initialEmailValue: emailAddress));
  }

  sentPasswordReset({required String emailAddress}) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);
  }

  logout(ProfileCubit profileCubit) {
    FirebaseAuth.instance.signOut();
    profileCubit.clearList();
    emit(const AuthenticationRegister());
  }
}
