import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';
import 'package:careshare/core/presentation/multi_select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../task_detailed_view/widgets/effort_icon.dart';

class TaskSearch extends StatefulWidget {
  static const String routeName = "/task-search";

  List<TaskStatus>? selectedStatuses;
  List<CareCategory> selectedCategories;
  List<Profile>? selectedProfiles;

  TaskSearch({
    Key? key,
    this.selectedStatuses,
    this.selectedCategories = const [],
    this.selectedProfiles,
  }) : super(key: key);

  @override
  _TaskSearchState createState() => _TaskSearchState();
}

class _TaskSearchState extends State<TaskSearch> {
  final TextEditingController _controller = TextEditingController();

  Iterable<CareCategory> _categoryList = [];
  Iterable<Profile> _profileList = [];

  bool firstTimeThrough = true;
  List<CareCategory> _selectedCategories = [];
  List<TaskStatus> _selectedStatuses = [];
  List<Profile> _selectedProfiles = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
      print("selectedStatuses: ${widget.selectedStatuses}");

      if (state is TaskLoaded) {
        if (firstTimeThrough == true) {
          _selectedCategories = widget.selectedCategories;
          _selectedStatuses = widget.selectedStatuses != null ? widget.selectedStatuses! : [];
          _selectedProfiles = widget.selectedProfiles != null ? widget.selectedProfiles! : [];

          _categoryList = BlocProvider.of<CategoriesCubit>(context).categoryList
              // .where((category) => state.careTaskList.firstWhere((task) => task.category != null && task.category!.id == category.id) != -1)
              ;

          _profileList = BlocProvider.of<AllProfilesCubit>(context).profileList;

          firstTimeThrough = false;
        }

        // filter
        List<CareTask> _filteredTaskList = state.careTaskList
            .where((task) =>
                // filter status
                (_selectedStatuses.isEmpty ||
                    task.taskStatus != TaskStatus.draft &&
                        _selectedStatuses.indexWhere((s) => s == task.taskStatus) != -1) &&

                // filter category
                (_selectedCategories.isEmpty ||
                    task.category != null && _selectedCategories.indexWhere((c) => c.id == task.category!.id) != -1) &&

                // filter profile
                (_selectedProfiles.isEmpty ||
                    (task.assignedTo != null && _selectedProfiles.indexWhere((p) => p.id == task.assignedTo) != -1) ||
                    (task.completedBy != null &&
                        _selectedProfiles.indexWhere((p) => p.id == task.completedBy) != -1)) &&

                // filter search
                (task.title.toUpperCase().contains(_controller.text.toUpperCase()) ||
                    task.details!.toUpperCase().contains(_controller.text.toUpperCase())))
            .toList();

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
                    _controller.text = "";
                    setState(() {});
                  },
                  icon: (_controller.text == "") ? const Icon(Icons.search) : const Icon(Icons.close),
                ),
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
            actions: [
              // Category Filter
              IconButton(
                  onPressed: () async {
                    final items = _categoryList.map((c) => MultiSelectDialogItem<CareCategory>(c, c.name)).toList();

                    final _categories = await showDialog<Set<CareCategory>>(
                      context: context,
                      builder: (BuildContext context) {
                        return MultiSelectDialog(
                          items: items,
                          initialSelectedValues: _selectedCategories.toSet(),
                        );
                      },
                    );

                    _selectedCategories = (_categories != null) ? _categories.toList() : [];
                    setState(() {});
                  },
                  icon: (_selectedCategories.isEmpty) ? const Icon(Icons.category_outlined) : const Icon(Icons.category)),

              // Profile Filter
              IconButton(
                  onPressed: () async {
                    final items = _profileList.map((c) => MultiSelectDialogItem<Profile>(c, c.name)).toList();

                    final _profiles = await showDialog<Set<Profile>>(
                      context: context,
                      builder: (BuildContext context) {
                        return MultiSelectDialog(
                          items: items,
                          initialSelectedValues: _selectedProfiles.toSet(),
                        );
                      },
                    );

                    _selectedProfiles = (_profiles != null) ? _profiles.toList() : [];
                    setState(() {});
                  },
                  icon: (_selectedProfiles.isEmpty) ? const Icon(Icons.people_alt_outlined) : const Icon(Icons.people_alt)),

              // Status Filter
              IconButton(
                  onPressed: () async {
                    final items = TaskStatus.taskStatusList
                        .where((s) => s != TaskStatus.draft)
                        .map((s) => MultiSelectDialogItem<TaskStatus>(s, s.status))
                        .toList();

                    final _statuses = await showDialog<Set<TaskStatus>>(
                      context: context,
                      builder: (BuildContext context) {
                        return MultiSelectDialog(
                          items: items,
                          initialSelectedValues: _selectedStatuses.toSet(),
                        );
                      },
                    );

                    _selectedStatuses = (_statuses != null) ? _statuses.toList() : [];
                    setState(() {});
                  },
                  icon: (_selectedCategories.isEmpty) ? const Icon(Icons.account_tree_outlined) : const Icon(Icons.account_tree)),
            ],
          ),
          body: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Column(
                children: [
                  //Show selected categories
                  (_selectedCategories.isNotEmpty)
                      ? Row(
                          children: [
                            const Text("category: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _selectedCategories.map((CareCategory c) {
                                    return Text("${c.name}, ",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900));
                                  }).toList(),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectedCategories = [];
                                setState(() {});
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),

                  //Show selected profiles
                  (_selectedProfiles.isNotEmpty)
                      ? Row(
                          children: [
                            const Text("people: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _selectedProfiles.map((Profile p) {
                                    return Text("${p.name}${", "}",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900));
                                  }).toList(),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectedProfiles = [];
                                setState(() {});
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),

                  //Show selected statuses
                  (_selectedStatuses.isNotEmpty)
                      ? Row(
                          children: [
                            const Text("status: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _selectedStatuses.map((TaskStatus s) {
                                    return Text("${s.status}, ",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900));
                                  }).toList(),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectedStatuses = [];
                                setState(() {});
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              elevation: 0,
              toolbarHeight: 20 +
                  (_selectedStatuses.isEmpty ? 0 : 20) +
                  (_selectedCategories.isEmpty ? 0 : 20) +
                  (_selectedProfiles.isEmpty ? 0 : 20),
              actions: const [],
            ),
            body: _filteredTaskList.isNotEmpty
                ? ListView(
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
                                        'Status: assigned to ${BlocProvider.of<AllProfilesCubit>(context).profileList.firstWhere((profile) => profile.id == task.assignedTo).name}'),
                                  if (task.taskStatus == TaskStatus.accepted)
                                    Text(
                                        'Status: accepted by ${BlocProvider.of<AllProfilesCubit>(context).profileList.firstWhere((profile) => profile.id == task.assignedTo).name}'),
                                  if (task.taskStatus == TaskStatus.completed)
                                    Text(
                                        'Status: completed by ${BlocProvider.of<AllProfilesCubit>(context).profileList.firstWhere((profile) => profile.id == task.assignedTo).name}'),
                                  if (task.taskStatus == TaskStatus.archived) Text('Status: ${task.taskStatus.status}'),
                                  if (task.taskStatus == TaskStatus.created || task.taskStatus == TaskStatus.assigned || task.taskStatus == TaskStatus.accepted) Text(
                                      'Due date: ${DateFormat('E d MMM yyyy').format(task.dueDate)}'),
                                  if (task.taskStatus == TaskStatus.completed || task.taskStatus == TaskStatus.archived) Text(
                                      'Completed date: ${DateFormat('E d MMM yyyy').format(task.taskCompletedDate!)}'),

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
                : ListView(
                    children: const [
                      Card(
                        child: ListTile(
                          title: Text("No tasks found"),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
