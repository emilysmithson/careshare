import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/invitation_manager/presenter/fetch_my_invitations_page.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class FetchCaregroupPage extends StatelessWidget {
  static const routeName = '/fetch-my-caregroups-page';
  const FetchCaregroupPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('fetching my caregroups');
    BlocProvider.of<CaregroupCubit>(context).fetchMyCaregroups(
        profile: BlocProvider.of<MyProfileCubit>(context).myProfile);

    return BlocBuilder<CaregroupCubit, CaregroupState>(
      builder: (context, state) {
        if (state is CaregroupLoading) {
          return const LoadingPageTemplate(
              loadingMessage: 'Loading caregroups...');
        }
        if (state is CaregroupError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is CaregroupsLoaded) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => Navigator.pushReplacementNamed(
                    context,
                    FetchMyInvitationsPage.routeName,
                  ));

          return Container();
        }
        return Container();
      },
    );
  }
}
