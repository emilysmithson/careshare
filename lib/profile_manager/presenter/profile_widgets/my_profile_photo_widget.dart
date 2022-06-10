import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfilePhotoWidget extends StatefulWidget {
  final double? size;

  const MyProfilePhotoWidget({Key? key, this.size}) : super(key: key);

  @override
  State<MyProfilePhotoWidget> createState() => _MyProfilePhotoWidgetState();
}

class _MyProfilePhotoWidgetState extends State<MyProfilePhotoWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(builder: (context, state) {
      if (state is MyProfileLoaded) {
        Profile myProfile = state.myProfile!;
        final photoURL = myProfile.photo;

        return Center(
          child: Container(
            height: widget.size ?? 40,
            width: widget.size ?? 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(photoURL), fit: BoxFit.cover),
            ),
          ),
        );
      }

      return Container();
    });
  }
}
