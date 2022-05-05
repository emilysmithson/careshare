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
    return PageScaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: BlocBuilder<CaregroupCubit, CaregroupState>(
            builder: (context, state) {
              return Column(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: NetworkImage(caregroup.photo!), fit: BoxFit.cover),
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
              );

              //   Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(caregroup.name,
              //         style: const TextStyle(fontWeight: FontWeight.bold)),
              //
              //     const SizedBox(height: spacing),
              //     CaregroupInputFieldWidget(
              //       label: 'First Name',
              //       maxLines: 1,
              //       currentValue: caregroup.firstName,
              //       caregroup: caregroup,
              //       onChanged: (value) {
              //         BlocProvider.of<CaregroupCubit>(context)
              //             .editCaregroupFieldRepository(
              //           caregroupField: CaregroupField.firstName,
              //           caregroup: caregroup,
              //           newValue: value,
              //         );
              //       },
              //     ),
              //     const SizedBox(height: spacing),
              //     CaregroupInputFieldWidget(
              //       label: 'Last Name',
              //       maxLines: 1,
              //       currentValue: caregroup.lastName,
              //       caregroup: caregroup,
              //       onChanged: (value) {
              //         BlocProvider.of<CaregroupCubit>(context)
              //             .editCaregroupFieldRepository(
              //           caregroupField: CaregroupField.lastName,
              //           caregroup: caregroup,
              //           newValue: value,
              //         );
              //       },
              //     ),
              //
              //     const SizedBox(height: spacing),
              //     CaregroupInputFieldWidget(
              //       label: 'Email',
              //       maxLines: 1,
              //       currentValue: caregroup.email,
              //       caregroup: caregroup,
              //       onChanged: (value) {
              //         BlocProvider.of<CaregroupCubit>(context)
              //             .editCaregroupFieldRepository(
              //           caregroupField: CaregroupField.email,
              //           caregroup: caregroup,
              //           newValue: value,
              //         );
              //       },
              //
              //     ),
              //
              //
              //     const SizedBox(height: spacing),
              //     Row(
              //       children: [
              //         ElevatedButton(
              //             onPressed: () {
              //               Navigator.pop(context);
              //             },
              //             child: const Text('Save')),
              //       ],
              //     ),
              //   ],
              // );
            },
          ),
        ),
      ),
    );
  }
}
