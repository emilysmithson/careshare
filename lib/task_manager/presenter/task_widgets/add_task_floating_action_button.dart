import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTaskFloatingActionButton extends StatefulWidget {
  const AddTaskFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTaskFloatingActionButton> createState() =>
      _AddTaskFloatingActionButtonState();
}

class _AddTaskFloatingActionButtonState
    extends State<AddTaskFloatingActionButton> {
  late PersistentBottomSheetController controller;
  TextEditingController textEditingController = TextEditingController();
  onSubmit() async {
    if (textEditingController.text.isEmpty) {
      return;
    }
    final taskCubit = BlocProvider.of<TaskCubit>(context);
    await taskCubit.createTask(textEditingController.text);
    Navigator.pop(context);
  }

  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: FloatingActionButton(
        onPressed: () async {
          setState(() {
            isVisible = false;
          });

          await showModalBottomSheet(
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                    child: SafeArea(
                  child: SizedBox(
                    height: 600,
                    child: Column(
                      children: [
                        Text(
                          'Create a new Task',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: textEditingController,
                            decoration: const InputDecoration(
                              label: Text('Enter your task name'),
                            ),
                            autofocus: true,
                            textCapitalization: TextCapitalization.sentences,
                            onSubmitted: (value) {
                              onSubmit();
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: onSubmit,
                              child: const Text('Create'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
              });
          setState(() {
            isVisible = true;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}