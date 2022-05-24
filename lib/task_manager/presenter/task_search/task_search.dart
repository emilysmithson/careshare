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
  String? statusFilter;
  String? categoryFilter;

  TaskSearch({
    Key? key,
    required this.caregroupId,
    this.statusFilter,
    this.categoryFilter,
  }) : super(key: key);

  @override
  _TaskSearchState createState() => _TaskSearchState();
}

class _TaskSearchState extends State<TaskSearch> {
  final TextEditingController _controller = TextEditingController();
  Iterable<CareCategory> _categoryList = [];

  Iterable<CareTask> _filteredTaskList = [];
  bool firstTimeThrough = true;

  String _categoryId = "";
  String _status = "";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
      if (state is TaskLoaded) {
        if (firstTimeThrough == true) {
          // _filteredTaskList = state.careTaskList
          //     .where((task) => task.taskStatus != TaskStatus.draft && task.caregroupId == widget.caregroupId)
          //     .take(10);

          _categoryList = BlocProvider.of<CategoriesCubit>(context).categoryList
              // .where((category) => state.careTaskList.firstWhere((task) => task.category != null && task.category!.id == category.id) != -1)
              ;
          print("_categoryList length: ${_categoryList.length}");

          List<Profile> _profileList = BlocProvider.of<AllProfilesCubit>(context).profileList;
          print("_profileList length: ${_profileList.length}");

          firstTimeThrough = false;
        }

        // print("categoryId: $categoryId");
        List<CareTask> _filteredTaskList = state.careTaskList
            .where((task) =>
                // filter status
                task.taskStatus != TaskStatus.draft &&
                (_status == "" ||
                task.taskStatus.status == _status) &&

                    // filter category
                    (_categoryId == "" || (task.category != null && task.category!.id == _categoryId)) &&
                    // filter search
                    (task.title.toUpperCase().contains(_controller.text.toUpperCase()) ||
                        task.details!.toUpperCase().contains(_controller.text.toUpperCase()))).toList();

        _filteredTaskList.sort((a, b) => a.taskSortDate!.compareTo(b.taskSortDate!));

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
                fillColor: Colors.white,
                filled: true,
                suffixIcon: IconButton(
                  onPressed: () {
                    _controller.text ="";
                    setState(() {});
                  },
                  icon: (_controller.text =="") ? Icon(Icons.search) : Icon(Icons.close) ,
                ),
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
            actions: [
              // Category Filter
              PopupMenuButton<String>(
                  tooltip: 'Category Filter',
                  icon: (_categoryId == "") ? Icon(Icons.category_outlined) : Icon(Icons.category),
                  onSelected: (String id) {
                    _categoryId = id;

                    setState(() {});
                  },
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuItem<String>> widgetList = _categoryList
                        .map(
                          (CareCategory category) => PopupMenuItem<String>(
                            value: category.id,
                            child: Text(category.name),
                            textStyle: (_categoryId == category.id)
                                ? TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                : TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                          ),
                        )
                        .toList();
                    widgetList.add(
                      PopupMenuItem<String>(
                        value: '',
                        child: Text('Show all'),
                        textStyle: (_categoryId == "")
                            ? TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                            : TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                    );
                    return widgetList;
                  }),

              // Status Filter
              PopupMenuButton<String>(
                  tooltip: 'Status Filter',
                  icon: (_status == "") ? Icon(Icons.account_tree_outlined) : Icon(Icons.account_tree),
                  onSelected: (String id) {
                    _status = id;

                    setState(() {});
                  },
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuItem<String>> widgetList = TaskStatus.taskStatusList
                        .where((status) => status != TaskStatus.draft)
                        .map(
                          (TaskStatus status) => PopupMenuItem<String>(
                            value: status.status,
                            child: Text(status.status),
                            textStyle: (_status == status.status)
                                ? TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                : TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                          ),
                        )
                        .toList();
                    widgetList.add(
                      PopupMenuItem<String>(
                        value: '',
                        child: Text('Show all'),
                        textStyle: (_status == "")
                            ? TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                            : TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                    );
                    return widgetList;
                  }),
            ],
          ),
          body: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Column(
                children: [
                  (_categoryId != "") ? Row(
                    children: [
                      Text("category: ",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                      Expanded(
                        child:
                        Text("${_categoryId!="" ? _categoryList.firstWhere((c) => c.id==_categoryId).name : ""} ",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),

                      ),
                      GestureDetector(
                        onTap: (){
                          _categoryId="";
                          setState(() {});
                          },
                        child: Icon(Icons.close),
                      ),

                    ],
                  ) : Container(),
                  (_status != "") ? Row(
                    children: [
                      Text("status: ",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                      Expanded(
                        child: Text("$_status",
                            style: TextStyle(fontSize: 16)),
                      ),
                      GestureDetector(
                        onTap: (){
                          _status = "";
                          setState(() {});
                        },
                        child: Icon(Icons.close),
                      ),
                    ],
                  ) : Container(),
                ],
              ),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              elevation: 0,
              toolbarHeight: (_status=="" && _categoryId=="" ) ? 20 : (_status!="" && _categoryId!="") ? 60 : 40,
              actions: [],
            ),
            body: ListView(
              children: _filteredTaskList
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
                          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Category: ${task.category?.name}'),
                            if (task.taskStatus == TaskStatus.draft) Text('Status: ${task.taskStatus.status}'),
                            if (task.taskStatus == TaskStatus.assigned)
                              Text(
                                  'Status: ${task.taskStatus.status} to ${BlocProvider.of<AllProfilesCubit>(context).profileList.firstWhere((profile) => profile.id == task.assignedTo).name}'),
                            if (task.taskStatus == TaskStatus.accepted)
                              Text(
                                  'Status: ${task.taskStatus.status} by ${BlocProvider.of<AllProfilesCubit>(context).profileList.firstWhere((profile) => profile.id == task.assignedTo).name}'),
                            if (task.taskStatus == TaskStatus.completed)
                              Text(
                                  'Status: ${task.taskStatus.status} by ${BlocProvider.of<AllProfilesCubit>(context).profileList.firstWhere((profile) => profile.id == task.assignedTo).name}'),
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
            ),
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
