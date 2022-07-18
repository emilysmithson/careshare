import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/kudos/kudos_board.dart';
import 'package:careshare/notification_manager/presenter/widgets/bell_widget.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';
import 'package:careshare/task_manager/presenter/task_search/task_search.dart';
import 'package:careshare/task_manager/presenter/widgets/task_section.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewCaregroupDashboard extends StatelessWidget {
  static const routeName = '/view-caregroup-dashboard';
  final Caregroup caregroup;

  const ViewCaregroupDashboard({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Profile _myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;
    List<Profile> _allProfiles = BlocProvider.of<AllProfilesCubit>(context).profileList;
    List<CareTask> _taskList = BlocProvider.of<TaskCubit>(context).taskList;

    return BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // Create a draft task and pass it to the edit screen
              final taskCubit = BlocProvider.of<TaskCubit>(context);
              final CareTask? task = await taskCubit.draftTask('', caregroup.id);
              if (task != null) {
                Navigator.pushNamed(
                  context,
                  TaskDetailedView.routeName,
                  arguments: task,
                );
              }
            },
            child: const Icon(Icons.add)),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(caregroup.name),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
          elevation: 0,
          toolbarHeight: 40,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                List<TaskStatus> _statuses = [];
                List<Profile> _profiles = [];
                List<CareCategory> _categories = [];
                Navigator.pushNamed(context, TaskSearch.routeName, arguments: {
                  "selectedStatuses": _statuses,
                  "selectedProfiles": _profiles,
                  "selectedCategories": _categories
                });
              },
            ),
            BellWidget(
              caregroup: caregroup,
            ),
            // IconButton(
            //   icon: const Icon(Icons.more_vert),
            //   onPressed: () {},
            // ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Carees
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(caregroup.photo!), fit: BoxFit.fitWidth),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Some info about the caregroup"),
                        Text("Some more info about the caregroup"),
                        Text("Some further info about the caregroup"),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    TaskSearch.routeName,
                    arguments: {
                      'selectedStatuses': [TaskStatus.created],
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Row(
                    children: [
                      Text(
                        'Members',
                        style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.play_circle_fill_outlined, size: 25, color: Colors.white),
                    ],
                  ),
                ),
              ),
              KudosBoard(
                profileList: _allProfiles
                    .where((profile) =>
                        profile.carerInCaregroups.where((element) => element.caregroupId == caregroup.id).isNotEmpty)
                    .toList(),
                caregroup: caregroup,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    TaskSearch.routeName,
                    arguments: {
                      'selectedStatuses': [TaskStatus.created],
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Row(
                    children: [
                      Text(
                        'Tasks',
                        style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.play_circle_fill_outlined, size: 25, color: Colors.white),
                    ],
                  ),
                ),
              ),
              TaskSection(
                title: 'Tasks',
                caregroup: caregroup,
                careTaskList: _taskList
                    // .where(
                    //   (element) => element.taskStatus == TaskStatus.created,
                    // )
                    .toList(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
