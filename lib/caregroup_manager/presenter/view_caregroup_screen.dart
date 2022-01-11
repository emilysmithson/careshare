import 'package:careshare/caregroup_manager/domain/models/caregroup.dart';
import 'package:careshare/caregroup_manager/domain/usecases/all_caregroup_usecases.dart';
import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/domain/usecases/all_profile_usecases.dart';
import 'package:careshare/profile_manager/presenter/view_profile_screen.dart';
import 'package:careshare/style/style.dart';
import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:careshare/widgets/item_widget.dart';
import 'package:flutter/material.dart';
import 'create_caregroup_screen.dart';
import 'view_caregroup_controller.dart';
import 'edit_caregroup_screen.dart';

class ViewCaregroupScreen extends StatefulWidget {
  final String caregroupId;
  ViewCaregroupScreen({
    Key? key,
    required this.caregroupId,
  }) : super(key: key);

  
  @override
  State<ViewCaregroupScreen> createState() =>
      _ViewCaregroupScreenState();
}

class _ViewCaregroupScreenState extends State<ViewCaregroupScreen> {
  late ViewCaregroupController controller = ViewCaregroupController();
  bool showCaregroupTypeError = false;

  bool isLoading = true;
  Caregroup? caregroup;
  List<Profile> profileList = [];
  List<Profile> careesInCaregroup = [];
  List<Profile> carersInCaregroup = [];

  Future fetchCaregroup(String id) async {
    final response = await AllCaregroupUseCases.fetchACaregroup(id);
    response.fold(
            (l) {
          // print(">l " + l.message);

          if (l.message=='no value'){
            // print('no value for this authId');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CreateCaregroupScreen()));
          }
        },
            (r) {
              caregroup = r;

          // // retrieve the carees
          // r.carees.toString().split(',').forEach((String profileId) async {
          //   final result = await AllProfileUseCases.fetchAProfile(profileId);
          //     result.fold((l) => null, (r) => careesInCaregroup.add(r));
          // });
          //
          // // retrieve the carers
          // r.carers.toString().split(',').forEach((String profileId) async {
          //   final result = await AllProfileUseCases.fetchAProfile(profileId);
          //   result.fold((l) => null, (r) => carersInCaregroup.add(r));
          // });

          isLoading = false;
          setState(() {});
        });
  }

  Future fetchProfiles() async {
    final response = await AllProfileUseCases.fetchProfiles();
    response.fold(
            (l) {
          // print(">l " + l.message);

          if (l.message=='no value'){
            print('no value for this authId');
          }
        },
            (r) {
          profileList = r;

          setState(() {});
        });
  }

  @override
  void initState() {
    fetchCaregroup(widget.caregroupId);
    fetchProfiles();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('>>>>>>>>>>>>>>>>>');
    print(profileList.length);


    careesInCaregroup = [];
    if (caregroup!.carees != null) {
      caregroup!.carees!.split(',').forEach((profileId) {
        careesInCaregroup.add(profileList.firstWhere((profile) => profile.id == profileId));
      });
    }
    print('}}}}}}}}}}}}}}}}${careesInCaregroup.length}');

    carersInCaregroup = [];
    if (caregroup!.carers != null) {
      caregroup!.carers!.split(',').forEach((profileId) {
        carersInCaregroup.add(profileList.firstWhere((profile) => profile.id == profileId));
      });
    }
    print('}}}}}}}}}}}}}}}}${carersInCaregroup.length}');

    if (isLoading){
      return Scaffold(
          body: Center(
              child: CircularProgressIndicator()
          )
      );
    }


    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar('Caregroup: ${this.caregroup!.name}'),
      endDrawer: CustomDrawer(),
      body: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(6),
        decoration: Style.boxDecoration,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              itemWidget(
                title: 'Name',
                content: caregroup!.name!,
              ),
              itemWidget(
                title: 'Details',
                content: caregroup!.details!,
              ),

              // Carees
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        'Carees' + ':',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: careesInCaregroup.map((e) =>
                              TextButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewProfileScreen(profile: e)));
                                },
                                child: Text(e.displayName!),

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

              // Carers
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        'Carers' + ':',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: carersInCaregroup.map((e) =>
                              TextButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewProfileScreen(profile: e)));
                                },
                                child: Text(e.displayName!),
                                
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
                title: 'Status',
                content: caregroup!.status.status,
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
                            builder: (context) => CreateOrEditACaregroupScreen(
                              caregroup: caregroup,
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
                        AllCaregroupUseCases.removeCaregroup(caregroup!.id!);
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

        ),
      ),
    );
  }
}