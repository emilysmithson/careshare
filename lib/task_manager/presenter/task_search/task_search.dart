import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';
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
  final TextEditingController _controller = TextEditingController();
  Iterable<CareCategory> _categoryList = [];

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
              // print("state.careTaskList length: ${state.careTaskList.length}");
              // print("_careTaskList length: ${_careTaskList.length}");

              _categoryList = BlocProvider.of<CategoriesCubit>(context).categoryList
                  // .where((category) => state.careTaskList.firstWhere((task) => task.category != null && task.category!.id == category.id) != -1)
              ;
              print("_categoryList length: ${_categoryList.length}");

              List<Profile> _profileList = BlocProvider.of<AllProfilesCubit>(context).profileList;
              print("_profileList length: ${_profileList.length}");

              firstTimeThrough= false;
            }

            return Scaffold(
              appBar: AppBar(
                title: TextField(
                  autofocus: true,

                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                  controller: _controller,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Search Tasks",
                    hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    border: const OutlineInputBorder(),
                    fillColor: Colors.white, filled: true,

                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),

                  ),
                  onChanged: (text) {
                    _careTaskList = state.careTaskList
                        .where((task) => task.taskStatus != TaskStatus.draft
                        && (task.title.toUpperCase().contains(_controller.text.toUpperCase())
                            || task.details!.toUpperCase().contains(_controller.text.toUpperCase())
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

                        // print("categoryId: $categoryId");
                        _careTaskList = state.careTaskList
                            .where((task) => task.taskStatus != TaskStatus.draft
                            && categoryId == "" || task.category != null &&  task.category!.id == categoryId
                            && (task.title.toUpperCase().contains(_controller.text.toUpperCase())
                                || task.details!.toUpperCase().contains(_controller.text.toUpperCase())
                            )
                        ).take(10);
                        setState(() {});
                      },
                      itemBuilder: (BuildContext context) {
                        List<PopupMenuItem<String>> widgetList =
                          _categoryList
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
                            value: '',
                            child: Text('Show all'),
                          ),
                        );
                        return widgetList;
                      }),

                ],
              ),


              body:
              ListView(
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
                              if (task.taskStatus == TaskStatus.draft) Text('Status: ${task.taskStatus.status}'),
                              if (task.taskStatus == TaskStatus.assigned) Text('Status: ${task.taskStatus.status} to ${BlocProvider.of<AllProfilesCubit>(context).profileList.firstWhere((profile) => profile.id==task.assignedTo).name}'),
                              if (task.taskStatus == TaskStatus.accepted) Text('Status: ${task.taskStatus.status} by ${BlocProvider.of<AllProfilesCubit>(context).profileList.firstWhere((profile) => profile.id==task.assignedTo).name}'),
                              if (task.taskStatus == TaskStatus.completed) Text('Status: ${task.taskStatus.status} by ${BlocProvider.of<AllProfilesCubit>(context).profileList.firstWhere((profile) => profile.id==task.assignedTo).name}'),
                              if (task.taskStatus == TaskStatus.archived) Text('Status: ${task.taskStatus.status}'),
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


            );
          }
          return const Center(child: CircularProgressIndicator());
        }
    );
  }
}


