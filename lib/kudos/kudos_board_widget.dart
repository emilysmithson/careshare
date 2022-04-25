import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:flutter/material.dart';

class KudosBoardWidget extends StatelessWidget {
  final Profile profile;
  const KudosBoardWidget({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: profile.name,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfilePhotoWidget(id: profile.id!),
            const SizedBox(width: 2),
            const Icon(Icons.star, size: 10),
            const SizedBox(width: 2),
            Text(
              profile.kudos.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
