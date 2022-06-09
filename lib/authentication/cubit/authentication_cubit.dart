
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  checkAuthentication() async {
    emit(AuthenticationLoading());
    // FirebaseAuth.instance.signOut();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(const AuthenticationLogin());
    } else {
      emit(AuthenticationLoaded(user));
    }

    // FirebaseAuth.instance
    //     .authStateChanges()
    //     .listen((User? user) {
    //   if (user == null) {
    //     print('FirebaseAuth.instance.authStateChanges().listen((User? user)  User is signed out');
    //         Navigator.pushNamed(
    //             navigatorKey.currentContext!, AuthenticationPage.routeName);
    //         emit(const AuthenticationLogin());
    //   } else {
    //     print('FirebaseAuth.instance.authStateChanges().listen((User? user)  User is signed in');
    //   }
    // });

    // FirebaseAuth.instance.authStateChanges().listen((event) {
    //   if (event == null) {
    //     Navigator.pushNamed(
    //         navigatorKey.currentContext!, AuthenticationPage.routeName);
    //     emit(const AuthenticationLogin());
    //   }
    // });
  }

  register({
    required String name,
    required String email,
    required String password,
    // required File photo,
  }) async {
    try {
      emit(AuthenticationLoading());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
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
      emit(
        AuthenticationRegistered(
          userId: user.uid,
          emailAddress: email,
          name: name,
          // photo: photo,
        ),
      );
    }
  }

  login({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return emit(AuthenticationLogin(
          errorMessage: 'No user found for that email.',
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

  logout(
      MyProfileCubit profileCubit,
      // TaskCubit taskCubit,
      // CaregroupCubit caregroupCubit,
      // InvitationsCubit invitationsCubit,
      // MyInvitationsCubit myInvitationsCubit,

      ) {
    FirebaseAuth.instance.signOut();
    emit(AuthenticationLoading());

    // NEED TO CLEAR EVERYTHING DOWN
    // profileCubit.clearProfile();
    // taskCubit.clearList();
    // caregroupCubit.clearList();
    // invitationsCubit.clearList();
    // myInvitationsCubit.clearList();

  }
}
