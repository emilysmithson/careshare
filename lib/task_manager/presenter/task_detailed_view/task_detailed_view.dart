import 'dart:async';

import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/notification_manager/cubit/notifications_cubit.dart';
import 'package:careshare/notification_manager/models/careshare_notification.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/assign_a_task.dart';
import 'widgets/choose_category_widget.dart';
import 'widgets/display_comments_widget.dart';
import 'widgets/effort_widget.dart';
import 'widgets/priority_widget.dart';
import 'widgets/task_workflow_widget.dart';
import 'package:intl/intl.dart';

class TaskDetailedView extends StatefulWidget {
  static const String routeName = "/task-detailed-view";
  final CareTask task;

  const TaskDetailedView({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskDetailedView> createState() => _TaskDetailedViewState();
}

class _TaskDetailedViewState extends State<TaskDetailedView> {
  final _formKey = GlobalKey<FormState>();
  Timer? _debounce;
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  bool _dirty = false;

  @override
  void initState() {
    titleController.text = widget.task.title;
    detailsController.text = (widget.task.details == null) ? "" : widget.task.details!;
    dueDateController.text = DateFormat('d MMM yyyy').format(widget.task.dueDate);
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    titleController.dispose();
    detailsController.dispose();
    dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CareTask originalTask = widget.task.clone();

    Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;
    Caregroup _caregroup =
        BlocProvider.of<CaregroupCubit>(context).myCaregroupList.firstWhere((c) => c.id == widget.task.caregroupId);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Scaffold(
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button
                  // Shown when the task is in Draft
                  // When clicked, the draft task is deleted

                  // Cancel Button
                  if (widget.task.taskStatus == TaskStatus.draft)
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<TaskCubit>(context).removeTask(widget.task.id);

                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  if (widget.task.taskStatus == TaskStatus.draft) const SizedBox(width: 20),

                  // Undo button
                  // Shown when _dirty is true
                  // When clicked, the task is reverted
                  if (widget.task.taskStatus != TaskStatus.draft && _dirty)
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<TaskCubit>(context).updateTask(originalTask);

                        Navigator.pop(context);
                      },
                      child: const Text('Undo Changes'),
                    ),
                  if (widget.task.taskStatus == TaskStatus.draft) const SizedBox(width: 20),

                  // Create Task button
                  // Shown when the task is in Draft
                  // When clicked, the status is set to:
                  //    Created if task isn't assigned
                  //    Assigned if the task is assigned to someone else
                  //    Accepted if the task is assigned to me
                  // A message is sent to everyone in the caregroup except me if the task is unassigned
                  // A message is sent to the assignee if the task is assigned
                  if (widget.task.taskStatus == TaskStatus.draft)
                    ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          print('validation failed');
                        } else {
                          BlocProvider.of<TaskCubit>(context).createTask(
                            task: widget.task,
                            profileId: myProfile.id,
                          );

                          Navigator.pop(context);

                          // Send a message to tell the world the task is created
                          final String id = DateTime.now().millisecondsSinceEpoch.toString();
                          final DateTime dateTime = DateTime.now();

                          final completionNotification = CareshareNotification(
                              id: id,
                              caregroupId: widget.task.caregroupId,
                              title: "${myProfile.displayName} has created a new task: ${widget.task.title}",
                              routeName: "/task-detailed-view",
                              subtitle: 'on ${DateFormat('E d MMM yyyy').add_jm().format(dateTime)}',
                              dateTime: dateTime,
                              senderId: myProfile.id,
                              isRead: false,
                              arguments: widget.task.id);

                          // send to everyone in the caregroup except me
                          List<String> recipientIds = [];
                          List<String> recipientTokens = [];
                          BlocProvider.of<AllProfilesCubit>(context).profileList.forEach((p) {
                            if (p.id != myProfile.id &&
                                p.carerInCaregroups
                                        .indexWhere((element) => element.caregroupId == widget.task.caregroupId) !=
                                    -1) {
                              recipientIds.add(p.id);
                              recipientTokens.add(p.messagingToken);
                            }
                          });

                          BlocProvider.of<NotificationsCubit>(context).sendNotifications(
                            notification: completionNotification,
                            recipientIds: recipientIds,
                            recipientTokens: recipientTokens,
                          );
                        }
                      },
                      child: const Text('Create Task'),
                    ),
                  if (widget.task.taskStatus == TaskStatus.draft) const SizedBox(width: 20),

                  // Accept Task Button
                  // Shown when the task is Assigned
                  if (widget.task.taskStatus == TaskStatus.assigned && widget.task.assignedTo == myProfile.id)
                    ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          print('validation failed');
                        } else {
                          BlocProvider.of<TaskCubit>(context).acceptTask(
                            task: widget.task,
                            profileId: myProfile.id,
                          );

                          Navigator.pop(context);

                          // Send a message to tell the creator the task is accepted
                          if (myProfile.id != widget.task.createdBy) {
                            final String id = DateTime.now().millisecondsSinceEpoch.toString();
                            final DateTime dateTime = DateTime.now();

                            final acceptNotification = CareshareNotification(
                                id: id,
                                caregroupId: widget.task.caregroupId,
                                title: "${myProfile.displayName} has accepted task: ${widget.task.title}",
                                routeName: "/task-detailed-view",
                                subtitle: 'on ${DateFormat('E d MMM yyyy').add_jm().format(dateTime)}',
                                dateTime: dateTime,
                                senderId: myProfile.id,
                                isRead: false,
                                arguments: widget.task.id);

                            // send to the task creator
                            String? recipientToken = BlocProvider.of<AllProfilesCubit>(context)
                                .profileList
                                .firstWhere((p) => p.id == widget.task.createdBy!)
                                .messagingToken!;

                            BlocProvider.of<NotificationsCubit>(context).sendNotifications(
                              notification: acceptNotification,
                              recipientIds: [widget.task.createdBy!],
                              recipientTokens: [recipientToken],
                            );
                          }
                        }
                      },
                      child: const Text('Accept Task'),
                    ),
                  if (widget.task.taskStatus == TaskStatus.assigned && widget.task.assignedTo == myProfile.id)
                    const SizedBox(width: 20),

                  TaskWorkflowWidget(
                    task: widget.task,
                    formKey: _formKey,
                  ),
                ],
              ),
              appBar: AppBar(
                title: const Text('Task Details'),
                actions: [
                  if (_caregroup.test)
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                      ),
                      onPressed: () {
                        final taskCubit = BlocProvider.of<TaskCubit>(context);

                        taskCubit.removeTask(widget.task.id);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Wrap(
                    runSpacing: 24,
                    children: [
                      Row(
                        children: [
                          ProfilePhotoWidget(id: widget.task.createdBy!),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                                "Created by: ${BlocProvider.of<AllProfilesCubit>(context).getName(widget.task.createdBy!)}"
                                "${widget.task.taskCreatedDate != null ? ' on ' : ''}"
                                "${widget.task.taskCreatedDate != null ? DateFormat('E d MMM yyyy').add_jm().format(widget.task.taskCreatedDate!) : ''}"),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('draft',
                                style: (widget.task.taskStatus == TaskStatus.draft)
                                    ? const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                                    : null),
                            const Text('  >  '),
                            Text('created',
                                style: (widget.task.taskStatus == TaskStatus.created)
                                    ? const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                                    : null),
                            const Text('  >  '),
                            Text('assigned',
                                style: (widget.task.taskStatus == TaskStatus.assigned)
                                    ? const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                                    : null),
                            const Text('  >  '),
                            Text('accepted',
                                style: (widget.task.taskStatus == TaskStatus.accepted)
                                    ? const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                                    : null),
                            const Text('  >  '),
                            Text('completed',
                                style: (widget.task.taskStatus == TaskStatus.completed)
                                    ? const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                                    : null),
                          ],
                        ),
                      ),
                      TextFormField(
                        enabled: !widget.task.taskStatus.locked,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          } else if (value.length < 10) {
                            return 'Too short! please make it at least 10 characters.';
                          }
                          return null;
                        },
                        // style: widget.textStyle,
                        maxLines: 1,
                        controller: titleController,
                        onChanged: (value) async {
                          _dirty = true;
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(const Duration(milliseconds: 100), () {
                            BlocProvider.of<TaskCubit>(context).editTask(
                              taskField: TaskField.title,
                              task: widget.task,
                              newValue: value,
                            );
                          });
                        },
                        decoration: const InputDecoration(
                          disabledBorder: (OutlineInputBorder(borderSide: BorderSide(color: Colors.black38))),
                          label: Text('Title'),
                        ),
                      ),
                      TextFormField(
                        enabled: !widget.task.taskStatus.locked,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          } else if (value.length < 20) {
                            return 'Too short! please make it   at least 20 characters.';
                          }
                          return null;
                        },
                        // style: widget.textStyle,
                        maxLines: 4,
                        controller: detailsController,
                        onChanged: (value) async {
                          _dirty = true;

                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(const Duration(milliseconds: 100), () {
                            BlocProvider.of<TaskCubit>(context).editTask(
                              taskField: TaskField.details,
                              task: widget.task,
                              newValue: value,
                            );
                          });
                        },
                        decoration: const InputDecoration(
                          disabledBorder: (OutlineInputBorder(borderSide: BorderSide(color: Colors.black38))),
                          label: Text('Description'),
                        ),
                      ),
                      TextFormField(
                        enabled: !widget.task.taskStatus.locked,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a due date';
                          }
                          return null;
                        },
                        // style: widget.textStyle,
                        maxLines: 1,
                        controller: dueDateController,
                        onChanged: (value) async {
                          _dirty = true;

                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(const Duration(milliseconds: 1000), () {
                            BlocProvider.of<TaskCubit>(context).editTask(
                              taskField: TaskField.dueDate,
                              task: widget.task,
                              newValue: value,
                            );
                          });
                        },

                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          disabledBorder: (OutlineInputBorder(borderSide: BorderSide(color: Colors.black38))),
                          label: Text('Due Date'),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            // print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            //you can implement different kind of Date Format here according to your requirement

                            BlocProvider.of<TaskCubit>(context).editTask(
                              taskField: TaskField.dueDate,
                              task: widget.task,
                              newValue: pickedDate,
                            );

                            setState(() {
                              dueDateController.text = DateFormat('d MMM yyyy').format(pickedDate);
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      ),
                      Row(
                        children: [
                          const Text('Can be done remotely'),
                          Checkbox(
                              value: widget.task.canBeRemote,
                              onChanged: (bool? value) {
                                _dirty = true;

                                if (!widget.task.taskStatus.locked) {
                                  BlocProvider.of<TaskCubit>(context).editTask(
                                    task: widget.task,
                                    newValue: value,
                                    taskField: TaskField.canBeRemote,
                                  );
                                }
                              }),
                        ],
                      ),
                      PriorityWidget(
                        locked: widget.task.taskStatus.locked,
                        task: widget.task,
                      ),
                      EffortWidget(
                        task: widget.task,
                        locked: widget.task.taskStatus.locked,
                      ),
                      ChooseCategoryWidget(
                        task: widget.task,
                        locked: widget.task.taskStatus.locked,
                      ),
                      AssignATask(
                        task: widget.task,
                        locked: widget.task.taskStatus.locked,
                      ),
                      DisplayCommentsWidget(task: widget.task),
                      const SizedBox(
                        height: 150,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
