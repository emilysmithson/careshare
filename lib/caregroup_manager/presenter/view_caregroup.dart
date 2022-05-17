import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_invitations.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_memebers.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_overview.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_tasks.dart';
import 'package:careshare/task_manager/models/task.dart';

import 'package:flutter/material.dart';

class ViewCaregroup extends StatefulWidget {
  static const routeName = '/view-caregroup';
  final Caregroup caregroup;
  final List<CareTask> careTaskList;

  const ViewCaregroup({
    Key? key,
    required this.caregroup,
    required this.careTaskList,
  }) : super(key: key);

  @override
  State<ViewCaregroup> createState() => _ViewCaregroupState();
}

class _ViewCaregroupState extends State<ViewCaregroup> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {


      return Scaffold(
        appBar: AppBar(
          title: const Text('Caregroup Details'),
          actions: const [],
        ),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () async {
        //       // InviteUserToCaregroup().call(context);
        //
        //       Navigator.of(context).pushNamed(InviteUserToCaregroup.routeName,
        //           arguments: widget.caregroup);
        //
        //       setState(() {});
        //     },
        //     child: const Icon(Icons.add)),
        body: SingleChildScrollView(
          child: Column(
            children: [

              Hero(
                tag: 'Caregroup',
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Caregroup: ${widget.caregroup.name}',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),


              (_selectedIndex == 0) ? ViewCaregroupTasks(caregroup: widget.caregroup, careTaskList: widget.careTaskList)
                  : (_selectedIndex == 1) ? ViewCaregroupOverview(caregroup: widget.caregroup)
                  : (_selectedIndex == 2) ? ViewCaregroupMembers(caregroup: widget.caregroup)
                  : (_selectedIndex == 3) ? ViewCaregroupInvitations(caregroup: widget.caregroup)
                  : Container(),

            ],
          ),
        ),


        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.summarize_outlined),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.summarize_outlined),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              label: 'Members',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail_outline),
              label: 'Invitations',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },

        ),
      );
  }
}
