import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/presenter/caregroup_widgets/caregroup_photo_widget.dart';
import 'package:careshare/invitation_manager/cubit/invitation_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:careshare/invitation_manager/models/invitation_status.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/task_manager/presenter/task_manager_view.dart';
import 'package:careshare/templates/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/home-page";
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

@override
  Widget build(BuildContext context) {

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {


          Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;

          // if i haven't accepted the Terms & Conditions, navigate to the T&C page
          if (myProfile.tandcsAccepted == false) {

            return PageScaffold(
                body: Column(
                    children: [
                      Hero(
                        tag: 'Caregroup',
                        child: Container(
                          width: double.infinity,
                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Careshare Terms and Conditions',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(width: 10),

                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text('Please accept the Terms and Conditions',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            const Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. '),
                            const SizedBox(height: 10),
                            const Text('Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                          onPressed: (){
                            // Set the accepted to true
                            BlocProvider.of<ProfileCubit>(context)
                                .editProfileFieldRepository(
                              profileField: ProfileField.tandcsAccepted,
                              profile: myProfile,
                              newValue: true,
                            );
                            setState(() {

                            });

                          },
                          child: Text('Accept')
                      ),
                  ]
              ),
            );
          }

          final allCaregroups = BlocProvider.of<CaregroupCubit>(context).caregroupList;

          final myCareGroupList = allCaregroups
              .where((caregroup) =>
                  myProfile.carerInCaregroups!.indexWhere(
                      (element) => element.caregroupId == caregroup.id) !=
                  -1)
              .toList();

          // invitationList is all my invitations to goups I'm not already part of, and where the status is 'invited'
          Iterable<Invitation> invitationList = BlocProvider.of<InvitationCubit>(context).invitationList
              .where((invitation) =>
                  invitation.email == myProfile.email &&
                  invitation.status == InvitationStatus.invited &&
                  myProfile.carerInCaregroups!.indexWhere((element) => element.caregroupId == invitation.caregroupId) == -1
          );


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
                          child: Column(
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
