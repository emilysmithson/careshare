import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/widgets/add_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DisplayCommentsWidget extends StatelessWidget {
  final CareTask task;
  const DisplayCommentsWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (task.comments == null) {
            return const Text('Comments');
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Comments'),
                Column(
                  children: task.comments!
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ],
                                )),
                          ),
                        ),
                      )
                      .toList(),
                ),
                Center(child: AddCommentWidget(task: task)),
              ],
            ),
          );
        },
      ),
    );
  }
}
