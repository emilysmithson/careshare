import 'package:bloc/bloc.dart';
import 'package:careshare/profile/cubit/profile_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  checkAuthentication() {
    emit(AuthenticationLoading());
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(AuthenticationRegister());
    } else {
      emit(AuthenticationLoaded(user));
    }
  }

  register({
    required String name,
    required String email,
    required String password,
    required ProfileCubit profileCubit,
  }) {
    try {
      emit(AuthenticationLoading());
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return emit(
            const AuthenticationError('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        return emit(const AuthenticationError(
            'The account already exists for that email.'));
      }
    }

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(AuthenticationRegister());
    } else {
      profileCubit.createProfile(
        email: email,
        name: name,
      );
      emit(AuthenticationLoaded(user));
    }
  }

  signIn({
    required String email,
    required String password,
    required String name,
  }) {
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return emit(const AuthenticationError('user found for that email.'));
      } else if (e.code == 'wrong-password') {
        return emit(
            const AuthenticationError('password provided for that user.'));
      }
    }
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(AuthenticationRegister());
    } else {
      user.updateDisplayName(name);
      emit(AuthenticationLoaded(user));
    }
  }

  resetPassword({
    required String email,
  }) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  switchToRegister() {
    emit(AuthenticationRegister());
  }

  switchToLogin() {
    emit(AuthenticationLogin());
  }

  switchToResetPassword() {
    emit(AuthenticationResetPassword());
  }

  signOut() {
    FirebaseAuth.instance.signOut();
    emit(AuthenticationRegister());
  }
}
