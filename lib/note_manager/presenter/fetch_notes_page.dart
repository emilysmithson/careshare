import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/note_manager/cubit/notes_cubit.dart';
import 'package:careshare/task_manager/presenter/fetch_tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetchNotesPage extends StatelessWidget {
  final Caregroup caregroup;
  static const routeName = '/fetch-notes-page';

  const FetchNotesPage({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('fetching notes for caregroup: ${caregroup.name}');

    BlocProvider.of<NotesCubit>(context).fetchNotesForCaregroup(caregroupId: caregroup.id);

    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        if (state is NotesLoading) {
          return const LoadingPageTemplate(loadingMessage: 'Loading notes...');
        }
        if (state is NotesError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is NotesLoaded) {
          WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Navigator.pushReplacementNamed(context, FetchTasksPage.routeName, arguments: caregroup));
          return Container();
        }
        return Container();
      },
    );
  }
}
