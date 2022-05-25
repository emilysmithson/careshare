import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/edit_caregroup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewCaregroupOverview extends StatelessWidget {
  static const routeName = '/view-caregroup-overview';
  final Caregroup caregroup;

  const ViewCaregroupOverview({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Container(
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: NetworkImage(caregroup.photo!),
                fit: BoxFit.fitWidth),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
                  children: [

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
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text('Details:',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(caregroup.details,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text('Type:',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(caregroup.type.type,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text('Status:',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(caregroup.status.status,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
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
                          child: Text(DateFormat('E d MMM yyyy').add_jm().format(caregroup.createdDate),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, EditCaregroup.routeName,
                                  arguments: caregroup);
                            },
                            child: const Text('Edit')),
                      ],
                    ),

                  ],


          ),
        ),
      ],
    );



  }
}
