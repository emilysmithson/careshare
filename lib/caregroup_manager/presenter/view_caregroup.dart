import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_chat.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_documents.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_invitations.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_memebers.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_overview.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_tasks.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';
import 'package:careshare/core/presentation/page_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewCaregroup extends StatefulWidget {
  static const routeName = '/view-caregroup';
  final Caregroup caregroup;
  final List<CareTask> careTaskList;

  const ViewCaregroup({
    Key? key,
    required this.caregroup,
    required this.careTaskList,
  }) : super(key: key);

  @override
  State<ViewCaregroup> createState() => _ViewCaregroupState();
}

class _ViewCaregroupState extends State<ViewCaregroup> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {


      return PageScaffold(
        searchScope: widget.caregroup.id,
        searchType: "Tasks",
        floatingActionButton: (_selectedIndex != 0) ? null : FloatingActionButton(
            onPressed: () async {
              // AddTaskBottomSheet().call(context);

              // Create a draft task and pass it to the edit screen
              final taskCubit = BlocProvider.of<TaskCubit>(context);
              final CareTask? task =
              await taskCubit.draftTask('', widget.caregroup.id);
              if (task != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TaskDetailedView(
                              task: task,
                    ),
                  ),
                );
              }
            },
            child: const Icon(Icons.add)),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.summarize_outlined),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Docs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.summarize_outlined),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              label: 'Members',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.mail_outline),
            //   label: 'Invitations',
            // ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },

        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                title: Text('Caregroup: ${widget.caregroup.name}'),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                elevation: 0,
                toolbarHeight: 40,
                actions: [
                  IconButton(icon: Icon(Icons.more_vert), onPressed: () {},),
                ],
              ),

              (_selectedIndex == 0) ? ViewCaregroupTasks(caregroup: widget.caregroup, careTaskList: widget.careTaskList)
                  : (_selectedIndex == 1) ? ViewCaregroupChat(caregroup: widget.caregroup)
                  : (_selectedIndex == 2) ? ViewCaregroupDocuments(caregroup: widget.caregroup)
                  : (_selectedIndex == 3) ? ViewCaregroupOverview(caregroup: widget.caregroup)
                  : (_selectedIndex == 4) ? ViewCaregroupMembers(caregroup: widget.caregroup)
                  // : (_selectedIndex == 5) ? ViewCaregroupInvitations(caregroup: widget.caregroup)
                  : Container(),

            ],
          ),
        ),



      );
  }
}
