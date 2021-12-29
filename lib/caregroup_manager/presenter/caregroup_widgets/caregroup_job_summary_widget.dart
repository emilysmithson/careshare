import 'package:flutter/material.dart';

import '../../../style/style.dart';
import '../../domain/models/caregroup.dart';
import '../../domain/usecases/all_caregroup_usecases.dart';
import '../create_or_edit_caregroup_screen.dart';
import '../../../widgets/item_widget.dart';

class CaregroupJobSummaryWidget extends StatelessWidget {
  final Caregroup caregroup;
  const CaregroupJobSummaryWidget({Key? key, required this.caregroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: Style.boxDecoration,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              itemWidget(
                title: 'Name',
                content: caregroup.name!,
              ),
              itemWidget(
                title: 'details',
                content: caregroup.details!,
              ),

              itemWidget(
                title: 'Carees',
                content: caregroup.carees!,
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
                        AllCaregroupUseCases.removeACaregroup(caregroup.id!);
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
    );
  }
}
