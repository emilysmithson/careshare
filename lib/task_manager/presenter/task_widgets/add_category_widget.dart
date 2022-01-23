import 'package:careshare/categories/cubit/categories_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCategoryWidget extends StatefulWidget {
  const AddCategoryWidget({Key? key}) : super(key: key);

  @override
  _AddCategoryWidgetState createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    onSubmit() {
      if (controller.text.isEmpty) {
        return;
      }
      Navigator.pop(context);
      BlocProvider.of<CategoriesCubit>(context).addCategory(
          name: controller.text,
          id: DateTime.now().millisecondsSinceEpoch.toString());
    }

    return IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                  child: SafeArea(
                child: SizedBox(
                  height: 600,
                  child: Column(
                    children: [
                      Text(
                        'Add a new category',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            label: Text('Enter category name'),
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
      },
      icon: const Icon(Icons.add),
    );
  }
}
