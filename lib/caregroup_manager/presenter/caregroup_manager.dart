import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/models/caregroup_type.dart';
import 'package:careshare/caregroup_manager/presenter/caregroup_widgets/caregroup_photo_widget.dart';
import 'package:careshare/caregroup_manager/presenter/edit_caregroup.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/task_manager/presenter/task_manager/task_manager_view.dart';
import 'package:careshare/templates/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaregroupManager extends StatefulWidget {
  static const String routeName = "/caregroup-manager";
  const CaregroupManager({
    Key? key,
  }) : super(key: key);

  @override
  _CaregroupManagerState createState() => _CaregroupManagerState();
}

class _CaregroupManagerState extends State<CaregroupManager> {

@override
  Widget build(BuildContext context) {

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {


          Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;

          final allCaregroups = BlocProvider.of<CaregroupCubit>(context).caregroupList;

          final myCareGroupList = allCaregroups
              .where((caregroup) =>
                  myProfile.carerInCaregroups!.indexWhere(
                      (element) => element.caregroupId == caregroup.id) !=
                  -1)
              .toList();


          return PageScaffold(
            floatingActionButton: FloatingActionButton(
                onPressed: () async {

                  // Create a draft caregroup and pass it to the edit screen
                  final caregroupCubit = BlocProvider.of<CaregroupCubit>(context);
                  final Caregroup? caregroup =
                  await caregroupCubit.draftCaregroup('');
                  if (caregroup != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<CaregroupCubit>(context),
                            child: BlocProvider.value(
                              value: BlocProvider.of<ProfileCubit>(context),
                              child: EditCaregroup(
                                caregroup: caregroup,
                              ),
                            ),
                          )
                      ),
                    );

                  }

                },
                child: const Icon(Icons.add)),
            body: Column(
              children: [
                SingleChildScrollView(
                  child: Wrap(
                    children: myCareGroupList
                        .map((caregroup) => GestureDetector(
                              onTap: () {
                                // navigate to the Task Manager
                                Navigator.pushNamed(
                                  context,
                                  TaskManagerView.routeName,
                                  arguments: caregroup,
                                );
                              },
                              child: Container(
                                width: 300,
                                height: 160,
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                      BlocBuilder<CaregroupCubit, CaregroupState>(
                                      builder: (context, state) {
                                        if (state is CaregroupLoaded) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CaregroupPhotoWidget(id: caregroup.id, size: 80),

                                                  const SizedBox(width: 16),

                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [

                                                        const SizedBox(height: 8),

                                                        Text(caregroup.name,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.bold)),


                                                        Text(caregroup.details,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                FontWeight.normal)),

                                                        Row(
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: (){
                                                                  Navigator.pushNamed(
                                                                    context,
                                                                    TaskManagerView.routeName,
                                                                    arguments: caregroup,
                                                                  );
                                                                },
                                                                child: const Text('View')
                                                            ),
                                                            const SizedBox(width: 8),
                                                            ElevatedButton(
                                                                onPressed: (){
                                                                  Navigator.pushNamed(
                                                                    context,
                                                                    EditCaregroup.routeName,
                                                                    arguments: caregroup,
                                                                  );
                                                                },
                                                                child: const Text('Edit')
                                                            ),
                                                          ],
                                                        ),


                                                      ],
                                                    ),
                                                  ),
                                                ],
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
                            ))
                        .toList(),
                  ),
                ),



              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}