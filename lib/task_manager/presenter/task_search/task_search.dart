import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';
import 'package:careshare/task_manager/presenter/task_overview/widgets/task_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../task_detailed_view/widgets/effort_icon.dart';

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
  TextEditingController _controller = TextEditingController();

  Iterable<CareTask> _careTaskList = [];
  bool firstTimeThrough = true;
  String categoryId = "";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {

            if (firstTimeThrough == true) {
              _careTaskList = state.careTaskList
                  .where((task) => task.taskStatus != TaskStatus.draft && task.caregroup == widget.caregroupId
              ).take(10);
              firstTimeThrough= false;
            }

            return Scaffold(
              appBar: AppBar(
                title: TextField(
                  autofocus: true,

                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  controller: _controller,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Search Tasks",
                    hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white, filled: true,

                    suffixIcon: IconButton(
                      onPressed: () {
                        // _careTaskList = state.careTaskList
                        //     .where((task) => task.taskStatus != TaskStatus.draft && task.caregroup == widget.caregroupId
                        //     &&
                        //     (task.title.toUpperCase().indexOf(controller.text.toUpperCase())!=-1
                        //         || task.details!.toUpperCase().indexOf(controller.text.toUpperCase())!=-1
                        //     )
                        //
                        // ).take(10);
                        // setState(() {});
                      },
                      icon: Icon(Icons.search),
                    ),

                  ),
                  onChanged: (text) {
                    _careTaskList = state.careTaskList
                        .where((task) => task.taskStatus != TaskStatus.draft && task.caregroup == widget.caregroupId
                        && task.category != null &&  task.category!.id == categoryId
                        && (task.title.toUpperCase().indexOf(_controller.text.toUpperCase())!=-1
                            || task.details!.toUpperCase().indexOf(_controller.text.toUpperCase())!=-1
                        )
                    ).take(10);
                    setState(() {});
                  },
                ),
                actions: [
                  PopupMenuButton<String>(
                      tooltip: 'Filter',
                      icon: const Icon(Icons.filter_alt),
                      onSelected: (String id) {
                        categoryId = id;

                        _careTaskList = state.careTaskList
                            .where((task) => task.taskStatus != TaskStatus.draft && task.caregroup == widget.caregroupId
                            && task.category != null &&  task.category!.id == categoryId
                            && (task.title.toUpperCase().indexOf(_controller.text.toUpperCase())!=-1
                                || task.details!.toUpperCase().indexOf(_controller.text.toUpperCase())!=-1
                            )
                        ).take(10);
                        setState(() {});
                      },
                      itemBuilder: (BuildContext context) {
                        List<PopupMenuItem<String>> widgetList =
                        BlocProvider.of<CategoriesCubit>(context)
                            .categoryList
                            .map(
                              (CareCategory category) =>
                              PopupMenuItem<String>(
                                value: category.id,
                                child: Text(category.name),
                              ),
                        )
                            .toList();
                        widgetList.add(
                          const PopupMenuItem<String>(
                            value: 'Show all',
                            child: Text('Show all'),
                          ),
                        );
                        return widgetList;
                      }),

                ],
              ),


              body: ListView(
                children: _careTaskList
                    .map(
                      (task) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        TaskDetailedView.routeName,
                        arguments: task,
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category: ${task.category?.name}'),
                            ]),
                        trailing: EffortIcon(
                          effort: task.taskEffort.value,
                        ),
                        leading: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: task.taskPriority.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    .toList(),
              )

            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //
            //
            //
            //     SizedBox(
            //
            //       child: Wrap(
            //         alignment: WrapAlignment.center,
            //         children: _careTaskList.map((task) {
            //           return Card(
            //             child: SizedBox(
            //               height: 60,
            //                 width: 160,
            //               child: Padding(
            //                 padding: const EdgeInsets.all(4.0),
            //                 child: Column(
            //                   children: [
            //                     Expanded(child: Text(task.title,
            //                         style: const TextStyle(fontWeight: FontWeight.bold),
            //                         overflow: TextOverflow.fade)
            //                     ),
            //                     Expanded(child: Text(task.title,
            //                         style: const TextStyle(fontWeight: FontWeight.normal),
            //                         overflow: TextOverflow.fade)
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           );
            //         }).toList(),
            //       ),
            //     )
            //       ],
            //
            //
            //     ),
            //   ),
            // )
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
    );
  }
}

