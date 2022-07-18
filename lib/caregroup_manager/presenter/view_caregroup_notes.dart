import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/note_manager/cubit/notes_cubit.dart';
import 'package:careshare/note_manager/models/note.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/note_manager/presenter/note_detailed_view.dart';
import 'package:careshare/notification_manager/presenter/widgets/bell_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;


class ViewCaregroupNotes extends StatefulWidget {
  static const routeName = '/view-caregroup-overview';
  final Caregroup caregroup;

  const ViewCaregroupNotes({
    required this.caregroup,
    Key? key,
  }) : super(key: key);

  @override
  State<ViewCaregroupNotes> createState() => _ViewCaregroupNotesState();
}

class _ViewCaregroupNotesState extends State<ViewCaregroupNotes> {
  TextEditingController noteController = TextEditingController();
  String? _selectedCategory = "";

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CareCategory> _categoryList = BlocProvider.of<CategoriesCubit>(context).categoryList;
    print("${_categoryList.length} categories loaded");
    if (_selectedCategory == "") {
      _selectedCategory = _categoryList[0].id;
    }

    BlocProvider.of<NotesCubit>(context).fetchNotes(caregroupId: widget.caregroup.id, categoryId: _selectedCategory!);

    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        if (state is NotesLoading) {
          return const //Text("loading note");
              LoadingPageTemplate(loadingMessage: 'Loading note...');
        }
        if (state is NotesError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is NotesLoaded) {
          List<Note> _noteList = BlocProvider.of<NotesCubit>(context).noteList.toList();

          return Scaffold(
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  // Create a draft task and pass it to the edit screen
                  final noteCubit = BlocProvider.of<NotesCubit>(context);
                  final Note? note = await noteCubit.draftNote(
                      widget.caregroup.id,
                      '',
                      _categoryList.firstWhere((c) => c.id == _selectedCategory),
                      '',
                      [],
                      quill.Document()..insert(0, 'New document...'),

                      ''
                  );
                  if (note != null) {
                    Navigator.pushNamed(
                      context,
                      NoteDetailedView.routeName,
                      arguments: {
                        'caregroup': widget.caregroup,
                        'noteId': note.id,
                      },
                    );
                  }
                },
                child: const Icon(Icons.add)),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(widget.caregroup.name),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              elevation: 0,
              toolbarHeight: 40,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                BellWidget(
                  caregroup: widget.caregroup,
                ),
                // IconButton(
                //   icon: const Icon(Icons.more_vert),
                //   onPressed: () {},
                // ),
              ],
            ),
            body: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 35,
                backgroundColor: Colors.blue[100],
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Note Category:",
                      style: TextStyle(fontSize: 16, color: Colors.blue[700], fontWeight: FontWeight.normal),
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueAccent,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                        child: DropdownButton(
                          isDense: true,
                          dropdownColor: Colors.white,
                          focusColor: Colors.white,
                          iconDisabledColor: Colors.white,
                          value: _selectedCategory,
                          items: _categoryList
                              .map((c) => DropdownMenuItem<String>(
                                    value: c.id,
                                    child: Text(
                                      c.name,
                                      style:
                                          TextStyle(fontSize: 16, color: Colors.blue[700], fontWeight: FontWeight.bold),
                                    ),
                                  ))
                              .toList(),

                          // style: TextStyle(
                          //   backgroundColor: Colors.white
                          // ),
                          onChanged: (item) {
                            setState(() {
                              // print(item);
                              _selectedCategory = item.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(4),
                          reverse: false,
                          children: _noteList.map((_note) {
                            return Card(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    NoteDetailedView.routeName,
                                    arguments: {"caregroup": widget.caregroup, "noteId": _note.id},
                                  );
                                },
                                child: ListTile(
                                  title: Text(_note.title),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_note.details!),
                                      Text('created: ${DateFormat('E d MMM yyyy').add_jm().format(_note.createdDate)}')
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
