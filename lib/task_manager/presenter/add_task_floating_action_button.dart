import 'package:careshare/task_manager/domain/usecases/all_task_usecases.dart';
import 'package:careshare/task_manager/presenter/task_view.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class AddTaskFloatingActionButton extends StatefulWidget {
  const AddTaskFloatingActionButton({Key? key}) : super(key: key);

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
    final result =
        await AllTaskUseCases.createATask(textEditingController.text);
    result.fold((l) {
      if (kDebugMode) {
        print('error: ${l.message}');
      }
    }, (r) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskView(task: r),
        ),
      );
    });
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