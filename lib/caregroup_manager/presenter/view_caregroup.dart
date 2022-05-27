import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_chat.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_invitations.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_memebers.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_overview.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_tasks.dart';
import 'package:careshare/notification_manager/cubit/notifications_cubit.dart';
import 'package:careshare/notification_manager/models/careshare_notification.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';
import 'package:careshare/core/presentation/page_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

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
    // update last access date
    BlocProvider.of<MyProfileCubit>(context).updateLastAccess(
        profile: BlocProvider.of<MyProfileCubit>(context).myProfile, caregroupId: widget.caregroup.id);

    // send caregroup reminders
    // thus needs to be moved to a scheduled task
    if (widget.caregroup.lastReminders == null ||
        widget.caregroup.lastReminders!.difference(DateTime.now()).inHours >= 24) {
      // caregroup XXX has X unallocated tasks that are late
      // Send a message to tell the world the task is created
      List<CareTask> taskList = BlocProvider.of<TaskCubit>(context)
          .taskList
          .where((task) => task.assignedTo!.isEmpty && task.taskStatus.complete == false && !task.dueDate.isAfter(DateTime.now()))
          .toList();
      taskList.forEach((task) {
        final String id = DateTime.now().millisecondsSinceEpoch.toString();
        final DateTime dateTime = DateTime.now();

        final completionNotification = CareshareNotification(
            id: id,
            caregroupId: task.caregroupId,
            title: "Task '${task.title}' is now past its due date",
            routeName: "/task-detailed-view",
            subtitle: 'on ${DateFormat('E d MMM yyyy').add_jm().format(dateTime)}',
            dateTime: dateTime,
            senderId: "",
            isRead: false,
            arguments: task.id);

        // send to everyone in the caregroup
        List<String> recipientIds = [];
        List<String> recipientTokens = [];
        BlocProvider.of<AllProfilesCubit>(context).profileList.forEach((p) {
          if (p.carerInCaregroups.indexWhere((element) => element.caregroupId == task.caregroupId) != -1) {
            recipientIds.add(p.id);
            if (p.messagingToken != null) {
              recipientTokens.add(p.messagingToken);
            }
          }
        });

        BlocProvider.of<NotificationsCubit>(context).sendNotifications(
          notification: completionNotification,
          recipientIds: recipientIds,
          recipientTokens: recipientTokens,
        );
      });

      // you have xxx tasks in caregroup XXX that are late

    }

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
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.library_books),
            //   label: 'Docs',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.summarize_outlined),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Members',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              label: 'Invitations',
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
        body: (_selectedIndex == 0)
            ? ViewCaregroupTasks(caregroup: widget.caregroup, careTaskList: widget.careTaskList)
            : (_selectedIndex == 1)
                ? ViewCaregroupChat(caregroup: widget.caregroup)
                : (_selectedIndex == 2)
                    ? ViewCaregroupOverview(caregroup: widget.caregroup)
                    : (_selectedIndex == 3)
                        ? ViewCaregroupMembers(caregroup: widget.caregroup)
                        : (_selectedIndex == 4)
                            ? ViewCaregroupInvitations(caregroup: widget.caregroup)
                            // : (_selectedIndex == 5) ? ViewCaregroupInvitations(caregroup: widget.caregroup)
                            : Container(),
      );
    });
  }
}
