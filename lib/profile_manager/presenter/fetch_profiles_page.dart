import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/task_manager/presenter/fetch_tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetchProfilesPage extends StatelessWidget {
  static const routeName = '/fetch-profiles-page';
  final Caregroup caregroup;

  const FetchProfilesPage({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('fetching profiles for caregroup: ${caregroup.name}');

    BlocProvider.of<AllProfilesCubit>(context).fetchProfiles(caregroupId: caregroup.id);

    return BlocBuilder<AllProfilesCubit, AllProfilesState>(
      builder: (context, state) {
        if (state is AllProfilesLoading) {
          return const LoadingPageTemplate(loadingMessage: 'Loading profiles...');
        }
        if (state is AllProfilesError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is AllProfilesLoaded) {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => Navigator.pushReplacementNamed(context, FetchTasksPage.routeName, arguments: caregroup));
          return Container();
        }
        return Container();
      },
    );
  }
}
