import 'package:careshare/core/presentation/photo_and_name_widget.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/task_cubit.dart';
import '../../../models/task.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TaskWorkflowCompleteWidget extends StatelessWidget {
  final CareTask task;
  const TaskWorkflowCompleteWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    return ElevatedButton(
      onPressed: () {},
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<TaskCubit>(context),
              child: BlocProvider.value(
                value: BlocProvider.of<ProfileCubit>(context),
                child: BlocBuilder<TaskCubit, TaskState>(
                  builder: (context, state) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          runSpacing: 16,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Mark as Complete',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                            ),
                            Text(
                              'Completed: ',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            SizedBox(
                              height: 120,
                              child: CupertinoDatePicker(
                                onDateTimeChanged: (DateTime dateTime) {
                                  dateTime = dateTime;
                                },
                              ),
                            ),
                            Text(
                              'Completed by: ',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            PhotoAndNameWidget(id: task.acceptedBy!),
                            SizedBox(
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: ()  async {

                                    BlocProvider.of<TaskCubit>(context)
                                        .completeTask(
                                      task: task,
                                      id: task.acceptedBy!,
                                      dateTime: dateTime,
                                    );

                                    Navigator.pop(context);

                                    Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;

                                    // Send a message to tell the world the task is complete
                                      HttpsCallable callable =
                                      FirebaseFunctions.instance.httpsCallable('completeTask');
                                      final resp = await callable.call(<String, dynamic>{
                                        'task_id': task.id,
                                        'task_title': task.title,
                                        'completer_id': myProfile.id,
                                        'completer_name': myProfile.name,
                                        'date_time': DateTime.now().toString()
                                      });


                                  },
                                  child: const Text('Ok'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
        child: const Text('Mark as complete'),
      ),
    );
  }
}
