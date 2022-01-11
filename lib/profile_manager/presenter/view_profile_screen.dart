import 'package:careshare/caregroup_manager/domain/models/caregroup.dart';
import 'package:careshare/caregroup_manager/domain/usecases/all_caregroup_usecases.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_screen.dart';
import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/domain/usecases/all_profile_usecases.dart';
import 'package:careshare/profile_manager/presenter/view_profile_controller.dart';
import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:careshare/widgets/item_widget.dart';
import 'package:flutter/material.dart';
import '../../../style/style.dart';

import 'edit_profile_screen.dart';


class ViewProfileScreen extends StatefulWidget {
  final String profileId;
  const ViewProfileScreen({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  late ViewProfileController controller = ViewProfileController();
  bool showCaregroupTypeError = false;

  bool isLoading = true;
  Profile? profile;
  List<Caregroup> caregroupList = [];
  List<Caregroup> careeInCaregroups = [];
  List<Caregroup> carerInCaregroups = [];


  Future fetchProfile(String id) async {
    final response = await AllProfileUseCases.fetchAProfile(id);
    response.fold(
            (l) {
          // print(">l " + l.message);

          if (l.message=='no value'){
            print('no value for this authId');
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CreateCaregroupScreen()));
          }
        },
            (r) {
          profile = r;
          isLoading = false;
          setState(() {});
        });
  }

  Future fetchCaregroups() async {
    final response = await AllCaregroupUseCases.fetchAllCaregroups()  ;
    response.fold(
            (l) {
          // print(">l " + l.message);

          if (l.message=='no value'){
            print('no value for this Id');
          }
        },
            (r) {
          caregroupList = r;

          setState(() {});
        });
  }


  @override
  void initState() {
    fetchProfile(widget.profileId);
    fetchCaregroups();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    careeInCaregroups = [];
    if (profile != null && profile!.careeIn != null) {

      profile!.careeIn!.split(',').forEach((caregroupId) {
        print('careeInCaregroups - caregroupId: $caregroupId');
        careeInCaregroups.add(caregroupList.firstWhere((caregroup) => caregroup.id == caregroupId));
      });
    }

    carerInCaregroups = [];
    if (profile != null && profile!.carerIn != null) {
      profile!.carerIn!.split(',').forEach((caregroupId) {
        print('carerInCaregroups - caregroupId: $caregroupId');
        carerInCaregroups.add(caregroupList.firstWhere((caregroup) => caregroup.id == caregroupId));
      });
    }

    if (isLoading){
      return Scaffold(
          body: Center(
              child: CircularProgressIndicator()
          )
      );
    }


    return Scaffold(
      appBar: CustomAppBar('Profile: ${this.profile!.displayName}'),
      endDrawer: CustomDrawer(),
      body: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(6),
        decoration: Style.boxDecoration,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                itemWidget(
                  title: 'First Name',
                  content: profile!.firstName!,
                ),
                itemWidget(
                  title: 'Last Name',
                  content: profile!.lastName!,
                ),
                itemWidget(
                  title: 'Display Name',
                  content: profile!.displayName!,
                ),

                itemWidget(
                  title: 'Task Types',
                  content: profile!.taskTypes!,
                ),

                itemWidget(
                  title: 'authId',
                  content: profile!.authId!,
                ),



                // Caree Groups
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          'Caree in Caregroups' + ':',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: careeInCaregroups.map((e) =>
                                TextButton(
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewCaregroupScreen(caregroupId: e.id!)));
                                  },
                                  child: Text(e.name!),

                                  style: TextButton.styleFrom(
                                    minimumSize: Size(22,22),
                                    padding: EdgeInsets.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )

                            ).toList()
                        ),
                      ),

                    ],
                  ),
                ),


                // Carer Groups
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          'Carer in Caregroups' + ':',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: carerInCaregroups.map((e) =>
                                TextButton(
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewCaregroupScreen(caregroupId: e.id!)));
                                  },
                                  child: Text(e.name!),

                                  style: TextButton.styleFrom(
                                    minimumSize: Size(22,22),
                                    padding: EdgeInsets.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )

                            ).toList()
                        ),
                      ),

                    ],
                  ),
                ),





                itemWidget(
                  title: 'Caree In',
                  content: this.profile!.careeIn ?? "",
                ),
                itemWidget(
                  title: 'Carer In',
                  content: this.profile!.carerIn ?? "",
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                profile: this.profile!,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          AllProfileUseCases.removeAProfile(this.profile!.id!);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                      ),


                    ],
                  ),
                ),

              ],
            ),



          ],
        ),
      )
    );
  }
}
