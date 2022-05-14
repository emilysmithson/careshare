import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/home_page/home_page.dart';
import 'package:careshare/invitation_manager/cubit/my_invitations_cubit.dart';
import 'package:careshare/my_profile/models/profile.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class FetchMyInvitationsPage extends StatelessWidget {
  static const routeName = '/fetch-my-invitations-page';
  const FetchMyInvitationsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('fetching my invitations');

    Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;
    List<Caregroup> myCaregroupList = BlocProvider.of<CaregroupCubit>(context).myCaregroupList;

    BlocProvider.of<MyInvitationsCubit>(context).fetchMyInvitations(email: myProfile.email, myCaregroupList: myCaregroupList);

    return BlocBuilder<MyInvitationsCubit, MyInvitationsState>(
      builder: (context, state) {
        if (state is MyInvitationsLoading) {
          return const LoadingPageTemplate(
              loadingMessage: 'Loading my invitations...');
        }
        if (state is MyInvitationsError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is MyInvitationsLoaded) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => Navigator.pushReplacementNamed(
            context,
            HomePage.routeName,
          ));
          return Container();
        }
        return Container();
      },
    );
  }
}
