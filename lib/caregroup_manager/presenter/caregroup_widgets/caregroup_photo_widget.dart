import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/caregroup_cubit.dart';

class CaregroupPhotoWidget extends StatelessWidget {
  final double? size;
  final String id;
  const CaregroupPhotoWidget({Key? key, required this.id, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (id.isEmpty) {
      return Container();
    }
    final photoURL = BlocProvider.of<CaregroupCubit>(context).getPhoto(id);

    if (photoURL != null) {
      return Center(
        child: Container(
          height: size ?? 40,
          width: size ?? 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: NetworkImage(photoURL), fit: BoxFit.cover),
          ),
        ),
      );
    }
    return Container();
  }
}
