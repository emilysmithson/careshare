import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../profile_manager/cubit/profile_cubit.dart';
import '../../profile_manager/presenter/profile_widgets/profile_photo_widget.dart';

class PhotoAndNameWidget extends StatelessWidget {
  final String id;
  final String text;
  final DateTime? dateTime;

  const PhotoAndNameWidget(
      {Key? key, required this.id, this.text = '', this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfilePhotoWidget(id: id),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
              "$text ${BlocProvider.of<ProfileCubit>(context).getName(id)}"
              "${dateTime != null ? 'on ' : ''}"
              "${dateTime != null ? DateFormat('E d MMM yyyy').add_jm().format(dateTime!) : ''}"),
        ),
      ],
    );
  }
}
