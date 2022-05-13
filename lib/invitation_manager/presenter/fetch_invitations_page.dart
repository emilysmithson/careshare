import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/invitation_manager/cubit/invitations_cubit.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/profile_manager/presenter/fetch_profiles_page.dart';
import 'package:careshare/task_manager/presenter/fetch_tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class FetchInvitationsPage extends StatelessWidget {
  static const routeName = '/fetch-invitations-page';
  final Caregroup caregroup;
  const FetchInvitationsPage({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('fetching invitations');


    BlocProvider.of<InvitationsCubit>(context).fetchInvitations(caregroupId: caregroup.id);

    return BlocBuilder<InvitationsCubit, InvitationState>(
      builder: (context, state) {
        if (state is InvitationLoading) {
          return const LoadingPageTemplate(
              loadingMessage: 'Loading invitations...');
        }
        if (state is InvitationError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is InvitationLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) =>
              Navigator.pushReplacementNamed(context, FetchTasksPage.routeName,
                  arguments: caregroup));
          return Container();
        }
        return Container();
      },
    );
  }
}
