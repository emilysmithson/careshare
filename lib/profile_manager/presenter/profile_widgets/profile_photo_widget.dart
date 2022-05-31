import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePhotoWidget extends StatelessWidget {
  final String id;
  final double? size;
  final String? photoURL;

  const ProfilePhotoWidget({Key? key,
    required this.id,
    this.size,
    this.photoURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (id.isEmpty) {
      return Container();
    }

    String _photoURL = "";
    if (photoURL != null) {
      _photoURL = photoURL!;
    } else {
      _photoURL = BlocProvider.of<AllProfilesCubit>(context).getPhoto(id)!;
    }
    if (photoURL != null) {
      return Center(
        child: Container(
          height: size ?? 40,
          width: size ?? 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage(_photoURL), fit: BoxFit.cover),
          ),
        ),
      );
    }
    return Container();
  }
}
