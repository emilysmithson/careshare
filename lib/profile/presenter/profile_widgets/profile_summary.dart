import 'package:careshare/categories/cubit/categories_cubit.dart';
import 'package:careshare/profile/cubit/profile_cubit.dart';
import 'package:careshare/profile/models/profile.dart';
import 'package:careshare/profile/presenter/profile_detailed_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSummary extends StatelessWidget {
  final Profile profile;

  const ProfileSummary({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<ProfileCubit>(context),
              child: BlocProvider.value(
                value: BlocProvider.of<ProfileCubit>(context),
                child: BlocProvider.value(
                  value: BlocProvider.of<CategoriesCubit>(context),
                  child: ProfileDetailedView(
                    profile: profile,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 190,
        height: 250,
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
