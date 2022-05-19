import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/widgets/add_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../profile_manager/cubit/my_profile_cubit.dart';

class DisplayCommentsWidget extends StatelessWidget {
  final CareTask task;
  const DisplayCommentsWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        label: Text("Comments"),
      ),
      child: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          task.comments?.sort(
            (a, b) => a.commentCreatedDate.compareTo(b.commentCreatedDate),
          );
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.comments != null)
                  Column(
                    children: task.comments!.map((comment) {
                      final bool isCommentByMe = comment.createdBy ==
                          BlocProvider.of<MyProfileCubit>(context).myProfile.id;
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isCommentByMe
                                    ? Colors.blue[100]
                                    : Colors.green[100],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  bottomLeft: isCommentByMe
                                      ? const Radius.circular(12)
                                      : const Radius.circular(0),
                                  topRight: const Radius.circular(12),
                                  bottomRight: isCommentByMe
                                      ? const Radius.circular(0)
                                      : const Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${comment.createdByDisplayName} on ${DateFormat('E d MMM yyyy').add_jm().format(comment.commentCreatedDate)}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  Text(comment.comment),
                                ],
                              )));
                    }).toList(),
                  ),
                Center(
                  child: AddCommentWidget(task: task),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
