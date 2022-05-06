import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/edit_caregroup.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewCaregroup extends StatelessWidget {
  static const routeName = '/view-caregroup';
  final Caregroup caregroup;

  const ViewCaregroup({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {

            final profileList = state.profileList
                .where((profile) => profile.carerInCaregroups!.indexWhere((element) => element.caregroupId==caregroup.id)!= -1);


            return Scaffold(
              appBar: AppBar(
                title: const Text('Caregroup Details'),
                actions: [],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: NetworkImage(caregroup.photo!),
                            fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text('Caregroup',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(caregroup.name,
                              style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text('Created',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(caregroup.createdDate.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),

                    const SizedBox(height: 16),
                    Table(
                        // border: TableBorder.all(
                        //     width: 4.0, color: Colors.white),

                        children: [
                          TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Member',style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Role',style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),

                              ]),
                          for (Profile profile in profileList) TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${profile.firstName} ${profile.lastName}'),
                                      ],
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${profile.carerInCaregroups!.firstWhere((element) => element.caregroupId==caregroup.id).role.role}'),
                                      ],
                                    ),
                                  ),
                                ),

                              ])
                        ]
                    ),


                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, EditCaregroup.routeName,
                                  arguments:
                                  caregroup);
                            },
                            child: const Text('Edit')),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
    );
  }
}