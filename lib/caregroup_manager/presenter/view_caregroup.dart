import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_chat.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_documents.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_memebers.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_overview.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_tasks.dart';
import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/notification_manager/presenter/widgets/bell_widget.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';
import 'package:careshare/core/presentation/page_scaffold.dart';
import 'package:careshare/task_manager/presenter/task_search/task_search.dart';

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
  final String _searchType = "Tasks";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
      return PageScaffold(
        // searchScope: widget.caregroup.id,
        // searchType: "Tasks",
        floatingActionButton: (_selectedIndex != 0)
            ? null
            : FloatingActionButton(
                onPressed: () async {
                  // Create a draft task and pass it to the edit screen
                  final taskCubit = BlocProvider.of<TaskCubit>(context);
                  final CareTask? task = await taskCubit.draftTask('', widget.caregroup.id);
                  if (task != null) {
                    Navigator.pushNamed(
                      context,
                      TaskDetailedView.routeName,
                      arguments: task,
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
        body: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(widget.caregroup.name),
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
            elevation: 0,
            toolbarHeight: 40,
            actions: [
              if (_searchType != "")
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_searchType == "Tasks") {
                      List<TaskStatus> _statuses = [];
                      List<Profile> _profiles = [];
                      List<CareCategory> _categories = [];
                      Navigator.pushNamed(context, TaskSearch.routeName,
                          arguments: {
                            "selectedStatuses": _statuses,
                            "selectedProfiles": _profiles,
                            "selectedCategories": _categories
                          });
                    }
                  },
                ),
              BellWidget(
                caregroup: widget.caregroup,
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          body: (_selectedIndex == 0)
              ? ViewCaregroupTasks(caregroup: widget.caregroup, careTaskList: widget.careTaskList)
              : (_selectedIndex == 1)
                  ? ViewCaregroupChat(caregroup: widget.caregroup)
                  : (_selectedIndex == 2)
                      ? ViewCaregroupDocuments(caregroup: widget.caregroup)
                      : (_selectedIndex == 3)
                          ? ViewCaregroupOverview(caregroup: widget.caregroup)
                          : (_selectedIndex == 4)
                              ? ViewCaregroupMembers(caregroup: widget.caregroup)
                              // : (_selectedIndex == 5) ? ViewCaregroupInvitations(caregroup: widget.caregroup)
                              : Container(),
        ),
      );
    });
  }
}
