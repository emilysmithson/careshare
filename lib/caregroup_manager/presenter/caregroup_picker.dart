import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/presenter/caregroup_widgets/caregroup_photo_widget.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/task_manager/presenter/task_manager_view.dart';
import 'package:careshare/templates/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaregroupPicker extends StatelessWidget {
  static const String routeName = "/caregroup-picker";
  const CaregroupPicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;

    return BlocBuilder<CaregroupCubit, CaregroupState>(
      builder: (context, state) {
        if (state is CaregroupLoaded) {
          return PageScaffold(
            body: SingleChildScrollView(
              child: Wrap(
                children: state.caregroupList.where((caregroup) =>  myProfile.carerInCaregroups!.indexWhere((element) => element.caregroupId==caregroup.id) != -1)
                    .map(
                      (caregroup) => GestureDetector(
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
                      )
                    )
                    .toList(),
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
