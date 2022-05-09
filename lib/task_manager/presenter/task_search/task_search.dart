import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_overview/widgets/task_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskSearch extends StatefulWidget {
  static const String routeName = "/task-search";
  final String caregroupId;
  const TaskSearch({
    Key? key,
    required this.caregroupId,
  }) : super(key: key);

  @override
  _TaskSearchState createState() => _TaskSearchState();
}

class _TaskSearchState extends State<TaskSearch> {
  TextEditingController controller = TextEditingController();

  Iterable<CareTask> _careTaskList = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {

            // _careTaskList = state.careTaskList
            //     .where((task) => task.taskStatus != TaskStatus.draft && task.caregroup == widget.caregroupId
            //   // &&
            //   // RegExp(
            //   //     r"\\b" + controller.text + "\\b", caseSensitive: false)
            //   //     .hasMatch(task.title)
            // ).take(10);


            return Scaffold(
              appBar: AppBar(
                title: const Text('Task Search'),
                actions: [],
              ),


              body:

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      controller: controller,
                      maxLines: 1,
                      decoration: InputDecoration(
                        label: Text("Search Tasks"),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _careTaskList = state.careTaskList
                                .where((task) => task.taskStatus != TaskStatus.draft && task.caregroup == widget.caregroupId
                                &&
                                (task.title.toUpperCase().indexOf(controller.text.toUpperCase())!=-1
                                || task.details!.toUpperCase().indexOf(controller.text.toUpperCase())!=-1
                                )

                            ).take(10);
                            setState(() {});
                          },
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),


                SizedBox(

                  child: Container(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: _careTaskList.map((task) {
                        return Card(
                          child: SizedBox(
                            height: 60,
                              width: 160,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                children: [
                                  Expanded(child: Text(task.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.fade)
                                  ),
                                  Expanded(child: Text(task.title,
                                      style: const TextStyle(fontWeight: FontWeight.normal),
                                      overflow: TextOverflow.fade)
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
                  ],


                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
    );
  }
}


