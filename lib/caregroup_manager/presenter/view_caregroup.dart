import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/edit_caregroup.dart';
import 'package:careshare/templates/page_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewCaregroup extends StatelessWidget {
  final Caregroup caregroup;
  static const routeName = '/view-caregroup';

  const ViewCaregroup({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const double spacing = 16;
    return BlocBuilder<CaregroupCubit, CaregroupState>(
        builder: (context, state) {
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
                            style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
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
    );
  }
}