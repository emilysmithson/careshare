import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/presenter/caregroup_widgets/caregroup_photo_widget.dart';
import 'package:careshare/invitation_manager/cubit/invitation_cubit.dart';
import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:careshare/invitation_manager/models/invitation_status.dart';
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

          Iterable<Invitation> invitationList = BlocProvider.of<InvitationCubit>(context).invitationList
              .where((invitation) => invitation.status==InvitationStatus.invited && invitation.email == myProfile.email);


          // If I am only in one caregroup, and I have no open invitations go straight to the TaskManagerView for that caregroup

          if (myCareGroupList.length == 1 && invitationList.isEmpty) {
            WidgetsBinding.instance?.addPostFrameCallback(
                  (_) => Navigator.pushNamed(
                context,
                TaskManagerView.routeName,
                arguments: myCareGroupList[0],
              ),
            );
            return Container();
          }


          return PageScaffold(
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

                                                        ElevatedButton(onPressed: (){
                                                          Navigator.pushNamed(
                                                            context,
                                                            TaskManagerView.routeName,
                                                            arguments: caregroup,
                                                          );
                                                        }, child: const Text('View')),
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


                SingleChildScrollView(
                  child: Wrap(
                    children: invitationList
                        .map((invitation) => GestureDetector(
                      onTap: () {},
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
                                if (invitationList.isNotEmpty) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CaregroupPhotoWidget(id: invitation.caregroupId, size: 80),

                                          const SizedBox(width: 16),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('You have been invited to join caregroup:',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.normal),
                                              ),
                                              Text(allCaregroups.firstWhere((caregroup) => caregroup.id==invitation.caregroupId).name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              ElevatedButton(onPressed: (){

                                                // Add the caregroup to my profile
                                                // double check that I'm not already in it
                                                // print("#############################################");
                                                // print(myProfile.carerInCaregroups!.indexWhere((element) => element.caregroupId == invitation.caregroupId));
                                                if (myProfile.carerInCaregroups!.indexWhere((element) => element.caregroupId == invitation.caregroupId) == -1){
                                                  BlocProvider.of<ProfileCubit>(context).addCarerInCaregroup(
                                                    profile: myProfile,
                                                    caregroupId: invitation.caregroupId,
                                                  );
                                                }

                                                // update the status of the invitation
                                                BlocProvider.of<InvitationCubit>(context)
                                                    .editInvitationFieldRepository(
                                                  invitationField: InvitationField.status,
                                                  invitation: invitation,
                                                  newValue: InvitationStatus.accepted,
                                                );

                                                // Navigate to the caregroup
                                                Navigator.pushNamed(
                                                  context,
                                                  TaskManagerView.routeName,
                                                  arguments: allCaregroups.firstWhere((caregroup) => caregroup.id==invitation.caregroupId),
                                                );

                                              }, child: const Text('Accept')),


                                            ],
                                        ),
                                          )
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
