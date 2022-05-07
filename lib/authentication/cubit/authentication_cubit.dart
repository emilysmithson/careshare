import 'dart:io';

import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/invitation_manager/cubit/invitation_cubit.dart';
import 'package:careshare/notifications/initialise_notifications.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../category_manager/cubit/category_cubit.dart';
import '../../notifications/presenter/cubit/notifications_cubit.dart';
import '../../task_manager/cubit/task_cubit.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  checkAuthentication({
    required BuildContext context,
  }) async {
    emit(AuthenticationLoading());

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(const AuthenticationLogin());
    } else {
      await initialise(
        context: context,
        userId: user.uid,
      );
      emit(AuthenticationLoaded(user));
    }
  }

  initialise({
    required BuildContext context,
    required String userId,
  }) async {
    await BlocProvider.of<ProfileCubit>(context).fetchProfiles();
    await BlocProvider.of<CaregroupCubit>(context).fetchCaregroups();
    await BlocProvider.of<TaskCubit>(context).fetchTasks();
    await BlocProvider.of<CategoriesCubit>(context).fetchCategories();
    await BlocProvider.of<CaregroupCubit>(context).fetchCaregroups();
    await BlocProvider.of<InvitationCubit>(context).fetchInvitations();

    await initialiseNotifications(userId, context);
    await BlocProvider.of<NotificationsCubit>(context).fetchNotifications();
  }

  register({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
    required File photo,
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
      await BlocProvider.of<ProfileCubit>(context).createProfile(
        id: FirebaseAuth.instance.currentUser!.uid,
        email: email,
        name: name,
        photo: photo,
        // careeInCaregroups: [],
        // carerInCaregroups: [],
      );
      await initialise(
        context: context,
        userId: user.uid,
      );
      emit(AuthenticationLoaded(user));
    }
  }

  login({
    required BuildContext context,
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
      await initialise(
        context: context,
        userId: user.uid,
      );

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
    emit(AuthenticationLoading());
    FirebaseAuth.instance.signOut();
    profileCubit.clearList();
    emit(const AuthenticationLogin());
  }
}
