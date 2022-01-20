import 'package:careshare/profile/models/profile.dart';
import 'package:careshare/profile/usecases/fetch_profiles.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/usecases/edit_task_field.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AssignToWidget extends StatefulWidget {
  final CareTask task;
  final FetchProfiles fetchProfiles;
  const AssignToWidget({
    Key? key,
    required this.task,
    required this.fetchProfiles,
  }) : super(key: key);

  @override
  _AssignToWidgetState createState() => _AssignToWidgetState();
}

class _AssignToWidgetState extends State<AssignToWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        List<Profile> profileList = widget.fetchProfiles.profileList;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
              title: const Text('Assign this task to:'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                      children:
                          profileList.map((e) => profileWidget(e)).toList()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final editTaskField = EditTaskField();
                          editTaskField(
                            newValue: null,
                            task: widget.task,
                            taskField: TaskField.acceptedBy,
                          );
                          editTaskField(
                            newValue: null,
                            task: widget.task,
                            taskField: TaskField.acceptedOnDate,
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Unassign'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ],
                  )
                ],
              )),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.task.acceptedBy == null ||
                  widget.task.acceptedBy!.isEmpty ||
                  widget.task.acceptedOnDate == null
              ? 'Assign this task...'
              : 'Assigned to: ${widget.fetchProfiles.getNickName(widget.task.acceptedBy!)} on ${DateFormat('E').add_jm().format(widget.task.acceptedOnDate!)}'),
        ),
      ),
    );
  }

  Widget profileWidget(Profile profile) {
    return GestureDetector(
      onTap: () {
        final editTaskField = EditTaskField();
        editTaskField(
          newValue: profile.id,
          task: widget.task,
          taskField: TaskField.acceptedBy,
        );
        editTaskField(
          newValue: DateTime.now(),
          task: widget.task,
          taskField: TaskField.acceptedOnDate,
        );
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        height: 70,
        width: 70,
        decoration: const BoxDecoration(
          color: Colors.yellow,
          shape: BoxShape.circle,
        ),
        child: Center(child: Text(profile.nickName)),
      ),
    );
  }
}
