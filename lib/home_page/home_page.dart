import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/caregroup_widgets/caregroup_photo_widget.dart';
import 'package:careshare/category_manager/presenter/fetch_categories_page.dart';
import 'package:careshare/invitation_manager/cubit/invitations_cubit.dart';
import 'package:careshare/invitation_manager/cubit/my_invitations_cubit.dart';
import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:careshare/invitation_manager/models/invitation_status.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/core/presentation/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:careshare/profile_manager/models/profile.dart';

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
    print('displaying Home Page');

    return BlocBuilder<CaregroupCubit, CaregroupState>(
      builder: (context, state) {
        if (state is CaregroupsLoaded) {
          Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;
          bool _showInvitationsOnHomePage = myProfile.showInvitationsOnHomePage;
          bool _showOtherCaregropusOnHomePage = myProfile.showOtherCaregropusOnHomePage;

          // if i haven't accepted the Terms & Conditions, navigate to the T&C page
          if (myProfile.tandcsAccepted == false) {
            return PageScaffold(
              body: Column(children: [
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
                          style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),
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
                    children: const [
                      Text('Please accept the Terms and Conditions', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. '),
                      SizedBox(height: 10),
                      Text(
                          'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?'),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      // Set the accepted to true
                      BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
                        profileField: ProfileField.tandcsAccepted,
                        profile: myProfile,
                        newValue: true,
                      );
                      setState(() {});
                    },
                    child: const Text('Accept Terms & Conditions')),
              ]),
            );
          }

          // All Caregropus
          List<Caregroup> allCaregroups = state.caregroupList;
          print('allCaregroups: ${allCaregroups.length}');

          // My Caregroups
          List<Caregroup> myCaregroups = state.myCaregroupList;
          print('myCaregroups: ${myCaregroups.length}');

          // My Invitations
          List<Invitation> myInvitationList = BlocProvider.of<MyInvitationsCubit>(context).myInvitationsList.toList();
          print('myInvitationList: ${myInvitationList.length}');

          if (myInvitationList.isEmpty) {
            _showInvitationsOnHomePage = false;
          }

          // Other Caregropus
          List<Caregroup> otherCaregroups = state.otherCaregroupList
              .where((caregroup) => myInvitationList.indexWhere((i) => i.caregroupId == caregroup.id) == -1)
              .toList();
          print('otherCaregroups: ${otherCaregroups.length}');

          if (otherCaregroups.isEmpty) {
            _showOtherCaregropusOnHomePage = false;
          }

          // If I am only in one caregroup, and I have no open invitations go straight to the TaskManagerView for that caregroup
          if (myCaregroups.length == 1 &&
              (_showInvitationsOnHomePage == false) &&
              (_showOtherCaregropusOnHomePage == false)) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => Navigator.pushNamed(
                context,
                FetchCategoriesPage.routeName,
                arguments: myCaregroups.first,
              ),
            );
            return Container();
          }

          return PageScaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // My Caregroups
                  AppBar(
                    title: Text("My Caregroups"),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                    elevation: 0,
                    toolbarHeight: 40,
                    actions: <Widget>[Container()],
                  ),
                  Wrap(
                    children: myCaregroups
                        .map((caregroup) => GestureDetector(
                              onTap: () {
                                // navigate to the Task Manager
                                Navigator.pushNamed(
                                  context,
                                  FetchCategoriesPage.routeName,
                                  arguments: caregroup,
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CaregroupPhotoWidget(id: caregroup.id, size: 50),
                                  ),
                                  title: Text(caregroup.name),
                                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(caregroup.details),
                                  ]),
                                  trailing: ElevatedButton(
                                      onPressed: () {
                                        // Add the caregroup to my profile
                                        // double check that I'm not already in it
                                        if (myProfile.carerInCaregroups
                                                .indexWhere((element) => element.caregroupId == caregroup.id) ==
                                            -1) {
                                          BlocProvider.of<MyProfileCubit>(context).addCarerInCaregroupToProfile(
                                            profileId: myProfile.id,
                                            caregroupId: caregroup.id,
                                          );
                                        }

                                        // Navigate to the caregroup
                                        Navigator.pushNamed(
                                          context,
                                          FetchCategoriesPage.routeName,
                                          arguments:
                                              allCaregroups.firstWhere((caregroup) => caregroup.id == caregroup.id),
                                        );
                                      },
                                      child: const Text('View')),
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  // Invitations
                  if (_showInvitationsOnHomePage)
                    const SizedBox(
                      height: 5,
                    ),
                  if (_showInvitationsOnHomePage)
                    AppBar(
                      title: Text("My Invitations"),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                      elevation: 0,
                      toolbarHeight: 40,
                      actions: <Widget>[Container()],
                        // IconButton(
                        //   icon: Icon(Icons.hide_image),
                        //   onPressed: () {
                        //     setState(() {
                        //       _showInvitationsOnHomePage == false;
                        //     });
                        //   },
                        // ),
                      // ],
                    ),
                  Wrap(
                    children: myInvitationList
                        .map((invitation) => GestureDetector(
                              onTap: () {},
                              child: Card(
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CaregroupPhotoWidget(id: invitation.caregroupId, size: 50),
                                  ),
                                  title: Text(allCaregroups
                                      .firstWhere((caregroup) => caregroup.id == invitation.caregroupId)
                                      .name),
                                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(allCaregroups
                                        .firstWhere((caregroup) => caregroup.id == invitation.caregroupId)
                                        .details),
                                  ]),
                                  trailing: ElevatedButton(
                                      onPressed: () {
                                        // Add the caregroup to my profile
                                        // double check that I'm not already in it
                                        if (allCaregroups
                                                .firstWhere((caregroup) => caregroup.id == invitation.caregroupId)
                                                .carers!
                                                .indexWhere((carer) => carer.profileId == myProfile.id) ==
                                            -1) {
                                          BlocProvider.of<CaregroupCubit>(context).addCarerInCaregroupToCaregroup(
                                            profileId: myProfile.id,
                                            caregroupId: invitation.caregroupId,
                                          );
                                        }

                                        // Add my profile to the caregroup
                                        // double check that I'm not already in it
                                        if (myProfile.carerInCaregroups.indexWhere(
                                                (element) => element.caregroupId == invitation.caregroupId) ==
                                            -1) {
                                          BlocProvider.of<MyProfileCubit>(context).addCarerInCaregroupToProfile(
                                            profileId: myProfile.id,
                                            caregroupId: invitation.caregroupId,
                                          );
                                        }

                                        // update the status of the invitation
                                        BlocProvider.of<InvitationsCubit>(context).editInvitationFieldRepository(
                                          invitationField: InvitationField.status,
                                          invitation: invitation,
                                          newValue: InvitationStatus.accepted,
                                        );

                                        // Navigate to the caregroup
                                        Navigator.pushNamed(
                                          context,
                                          FetchCategoriesPage.routeName,
                                          arguments: allCaregroups
                                              .firstWhere((caregroup) => caregroup.id == invitation.caregroupId),
                                        );
                                      },
                                      child: const Text('Accept Invitation')),
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  // Other Caregropus
                  if (_showOtherCaregropusOnHomePage)
                    const SizedBox(
                      height: 5,
                    ),
                  if (_showOtherCaregropusOnHomePage)
                    AppBar(
                      title: Text("Other Caregroups"),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                      elevation: 0,
                      toolbarHeight: 40,
                      actions: <Widget>[Container()],
                        // IconButton(
                        //   icon: Icon(Icons.pin_drop_outlined),
                        //   onPressed: () {
                        //     setState(() {
                        //       _showOtherCaregropusOnHomePage == false;
                        //     });
                        //   },
                        // ),
                      // ],
                    ),
                  Wrap(
                    children: otherCaregroups
                        .map((caregroup) => GestureDetector(
                              onTap: () {
                                // navigate to the Task Manager
                                Navigator.pushNamed(
                                  context,
                                  FetchCategoriesPage.routeName,
                                  arguments: caregroup,
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CaregroupPhotoWidget(id: caregroup.id, size: 50),
                                  ),
                                  title: Text(caregroup.name),
                                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(caregroup.details),
                                  ]),
                                  trailing: ElevatedButton(onPressed: () {}, child: const Text('Request Access')),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
