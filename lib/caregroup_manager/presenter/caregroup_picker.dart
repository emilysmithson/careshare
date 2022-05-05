import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/caregroup_widgets/caregroup_photo_widget.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/task_manager/presenter/task_manager_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaregroupPicker extends StatelessWidget {
  static const String routeName = "/caregroup-picker";
  final Caregroup caregroup;

  const CaregroupPicker({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;

    // you shouldn't be able to see this page if you aren't a memeber of the caregroup
    int indexWhere = myProfile.carerInCaregroups!.indexWhere((element) => element.caregroupId==caregroup.id);
    if (indexWhere == -1) return Scaffold();

    return GestureDetector(
      onTap: () {

        // navigate to the Task Manager
        Navigator.pushNamed(
          context,
          TaskManagerView.routeName,
          arguments: caregroup,
        );
      },
      child: Container(
        width: 250,
        height: 200,
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<CaregroupCubit, CaregroupState>(
              builder: (context, state) {
                if (state is CaregroupLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CaregroupPhotoWidget(id: caregroup.id, size: 80),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(caregroup.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
