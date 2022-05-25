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

import '../task_detailed_view/widgets/effort_icon.dart';

class TaskSearch extends StatefulWidget {
  static const String routeName = "/task-search";
  final String caregroupId;

  List<TaskStatus> selectedStatuses;
  List<CareCategory> selectedCategories;
  List<Profile> selectedProfiles;

  TaskSearch({
    Key? key,
    required this.caregroupId,
    this.selectedStatuses = const [],
    this.selectedCategories = const [],
    this.selectedProfiles = const [],
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
      if (state is TaskLoaded) {
        if (firstTimeThrough == true) {
          _selectedCategories = widget.selectedCategories;
          _selectedStatuses = widget.selectedStatuses;
          _selectedProfiles = widget.selectedProfiles;
          
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
                (_selectedStatuses.isEmpty || task.taskStatus != TaskStatus.draft &&
                _selectedStatuses.indexWhere((s) => s == task.taskStatus) != -1) &&

                    // filter category
                    (_selectedCategories.isEmpty || task.category != null && _selectedCategories.indexWhere((c) => c.id == task.category!.id) != -1) &&

                    // filter profile
                    (_selectedProfiles.isEmpty ||
                        (task.assignedTo != null && _selectedProfiles.indexWhere((p) => p.id == task.assignedTo) != -1) ||
                          (task.completedBy != null && _selectedProfiles.indexWhere((p) => p.id == task.completedBy) != -1)
                    ) &&

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
                  icon: (_controller.text == "") ? Icon(Icons.search) : Icon(Icons.close),
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
                  icon: (_selectedCategories.isEmpty) ? Icon(Icons.category_outlined) : Icon(Icons.category)),

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
                  icon: (_selectedProfiles.isEmpty) ? Icon(Icons.people_alt_outlined) : Icon(Icons.people_alt)),

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
                  icon: (_selectedCategories.isEmpty) ? Icon(Icons.account_tree_outlined) : Icon(Icons.account_tree)),
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
                            Text("category: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _selectedCategories.map((CareCategory c) {
                                    return Text("${c.name}, ",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900));
                                  }).toList(),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectedCategories = [];
                                setState(() {});
                              },
                              child: Icon(Icons.close),
                            ),
                          ],
                        )
                      : Container(),

                  //Show selected profiles
                  (_selectedProfiles.isNotEmpty)
                      ? Row(
                    children: [
                      Text("people: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _selectedProfiles.map((Profile p) {
                              return Text("${p.name}, ",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900));
                            }).toList(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectedProfiles = [];
                          setState(() {});
                        },
                        child: Icon(Icons.close),
                      ),
                    ],
                  )
                      : Container(),
                  
                  //Show selected statuses
                  (_selectedStatuses.isNotEmpty)
                      ? Row(
                          children: [
                            Text("status: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _selectedStatuses.map((TaskStatus s) {
                                    return Text("${s.status}, ",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900));
                                  }).toList(),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectedStatuses = [];
                                setState(() {});
                              },
                              child: Icon(Icons.close),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              elevation: 0,
              toolbarHeight: 20 + (_selectedStatuses.isEmpty ? 0 : 20) + (_selectedCategories.isEmpty ? 0 : 20) + (_selectedProfiles.isEmpty ? 0 : 20),
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
