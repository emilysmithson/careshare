import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DisplayCommentsWidget extends StatelessWidget {
  final CareTask task;
  const DisplayCommentsWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return Column(
          children: task.comments
              .map(
                (comment) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment.commment),
                            Text(
                                '${comment.createdByDisplayName} on ${DateFormat('E').add_jm().format(comment.dateCreated)}',
                                style: Theme.of(context).textTheme.caption),
                          ],
                        )),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}