import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:careshare/profile_manager/models/profile.dart';

class ViewProfile extends StatelessWidget {
  final Profile profile;
  static const routeName = '/view-profile';

  const ViewProfile({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;

    // const double spacing = 16;
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('User Details'),
            actions: const [],
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
                        image: NetworkImage(profile.photo), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Username',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(profile.displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Email',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(profile.email,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
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
                      child: Text(profile.createdDate.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                if (profile == myProfile)
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, EditProfile.routeName,
                                arguments:
                                    BlocProvider.of<MyProfileCubit>(context)
                                        .myProfile);
                          },
                          child: const Text('Edit')),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
