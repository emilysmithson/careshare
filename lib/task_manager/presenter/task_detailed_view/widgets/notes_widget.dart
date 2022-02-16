import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/task_cubit.dart';
import '../../../models/task.dart';

class NotesWidget extends StatefulWidget {
  final CareTask task;
  const NotesWidget({Key? key, required this.task}) : super(key: key);

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller =
        TextEditingController(text: widget.task.details);

    return GestureDetector(onTap: () {
      showDialog(
        context: context,
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<TaskCubit>(context),
          child: AlertDialog(
            title: const Text('Notes'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                autofocus: true,
                controller: controller,
                maxLines: null,
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<TaskCubit>(context).editTaskFieldRepository(
                      task: widget.task,
                      newValue: controller.text,
                      taskField: TaskField.details,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Save'))
            ],
          ),
        ),
      );
    }, child: BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (widget.task.details == null || widget.task.details == '') {
          return const Text('+ Add notes');
        }
        return Text(widget.task.details!);
      },
    ));
  }
}
