import 'dart:async';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/note_manager/cubit/note_cubit.dart';
import 'package:careshare/note_manager/models/note.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NoteDetailedView extends StatefulWidget {
  static const routeName = '/note-detailed-view';
  final Caregroup caregroup;
  final Note note;

  const NoteDetailedView({
    required this.caregroup,
    required this.note,
    Key? key,
  }) : super(key: key);

  @override
  State<NoteDetailedView> createState() => _NoteDetailedViewState();
}

class _NoteDetailedViewState extends State<NoteDetailedView> {
  final _formKey = GlobalKey<FormState>();
  Timer? _debounce;
  bool _dirty = false;

  TextEditingController titleController = TextEditingController();
  quill.QuillController? _controller;

  @override
  void dispose() {
    titleController.dispose();
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        print(state);
        if (state is NotesLoading) {
          return const //Text("loading note");
              LoadingPageTemplate(loadingMessage: 'Loading note...');
        }
        if (state is NoteError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is NotesLoaded) {
          List<Note> _noteList = BlocProvider.of<NoteCubit>(context).noteList;
          Note _note = _noteList.firstWhere((n) => n.id == widget.note.id);
          print(_note.toString());

          titleController.text = _note.title;
          _controller =
              quill.QuillController(document: widget.note.content!, selection: const TextSelection.collapsed(offset: 0));

          _controller!.document.changes.listen((event) async {


            _dirty = true;
            if (_debounce?.isActive ?? false) _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 1000), () {

              print("item1: ${event.item1}");
              print("delta: ${event.item2}");
              print("source: ${event.item3}");

              BlocProvider.of<NoteCubit>(context).editNote(
                noteField: NoteField.content,
                note: widget.note,
                newValue: _controller!.document,
                // newValue: quill.Document.fromDelta(_controller!.document.toDelta()),
              );
            });
          });


          return Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Note Details'),
                actions: [
                  if (widget.caregroup.test)
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                      ),
                      onPressed: () {
                        final noteCubit = BlocProvider.of<NoteCubit>(context);

                        noteCubit.removeNote(widget.note.id);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Wrap(
                    runSpacing: 24,
                    children: [
                      Row(
                        children: [
                          ProfilePhotoWidget(id: widget.note.createdById),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                                "Created by: ${BlocProvider.of<AllProfilesCubit>(context).getName(widget.note.createdById)}"
                                "${widget.note.createdDate != null ? ' on ' : ''}"
                                "${widget.note.createdDate != null ? DateFormat('E d MMM yyyy').add_jm().format(widget.note.createdDate) : ''}"),
                          ),
                        ],
                      ),
                      TextFormField(
                        // enabled: !widget.note.noteStatus.locked,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          } else if (value.length < 10) {
                            return 'Too short! please make it at least 10 characters.';
                          }
                          return null;
                        },
                        // style: widget.textStyle,
                        maxLines: 1,
                        controller: titleController,
                        onChanged: (value) async {
                          _dirty = true;
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(const Duration(milliseconds: 100), () {
                            BlocProvider.of<NoteCubit>(context).editNote(
                              noteField: NoteField.title,
                              note: widget.note,
                              newValue: value,
                            );
                          });
                        },
                        decoration: const InputDecoration(
                          disabledBorder: (OutlineInputBorder(borderSide: BorderSide(color: Colors.black38))),
                          label: Text('Title'),
                        ),
                      ),


                      quill.QuillEditor.basic(
                        controller: _controller!,
                        readOnly: false,

                      ),
                      quill.QuillToolbar.basic(
                          controller: _controller!,
                      toolbarIconAlignment: WrapAlignment.start,
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
