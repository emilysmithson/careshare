import 'dart:io';

import 'package:careshare/caregroup_manager/presenter/fetch_caregroup_page.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/my_profile_cubit.dart';

class FetchMyProfilePage extends StatelessWidget {
  final String id;
  final bool createProfile;
  final File? photo;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? email;

  static const routeName = '/fetch-my-profile-page';
  const FetchMyProfilePage(
      {Key? key,
      required this.id,
      this.createProfile = false,
      this.photo,
      this.name,
      this.firstName,
      this.lastName,
      this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('fetching my profile');
    if (createProfile) {
      BlocProvider.of<MyProfileCubit>(context).createProfile(
        // photo: photo,
        // name: name,
        email: email,
        id: id,
      );
    } else {
      BlocProvider.of<MyProfileCubit>(context).fetchMyProfile(id);
    }
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        if (state is MyProfileLoading) {
          return const LoadingPageTemplate(
              loadingMessage: 'Loading profile...');
        }
        if (state is MyProfileError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is MyProfileLoaded) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => Navigator.pushReplacementNamed(
                    context,
                    FetchCaregroupPage.routeName,
                  ));

          return Container();
        }
        return Container();
      },
    );
  }
}
