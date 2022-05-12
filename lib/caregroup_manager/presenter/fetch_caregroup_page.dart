import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../profile_manager/cubit/profile_cubit.dart';
import 'caregroup_manager.dart';

class FetchCaregroupPage extends StatelessWidget {
  static const routeName = '/fetch-my-caregroups-page';
  const FetchCaregroupPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CaregroupCubit>(context).fetchMyCaregroups(
        profile: BlocProvider.of<ProfileCubit>(context).myProfile);

    return BlocBuilder<CaregroupCubit, CaregroupState>(
      builder: (context, state) {
        if (state is CaregroupLoading) {
          return const LoadingPageTemplate(
              loadingMessage: 'Loading your caregroups...');
        }
        if (state is CaregroupError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is CaregroupLoaded) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => Navigator.pushReplacementNamed(
                    context,
                    CaregroupManager.routeName,
                  ));

          return Container();
        }
        return Container();
      },
    );
  }
}
