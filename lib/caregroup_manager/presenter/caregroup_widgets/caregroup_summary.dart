import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/edit_caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/caregroup_widgets/caregroup_photo_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaregroupSummary extends StatelessWidget {
  static const String routeName = "/caregroup-summary";
  final Caregroup caregroup;

  const CaregroupSummary({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          EditCaregroup.routeName,
          arguments: caregroup,
        );
      },
      child: Container(
        width: 250,
        height: 200,
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<CaregroupCubit, CaregroupState>(
              builder: (context, state) {
                if (state is CaregroupLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CaregroupPhotoWidget(id: caregroup.id, size: 80),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(caregroup.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}
