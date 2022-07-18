import 'dart:async';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/note_manager/cubit/note_cubit.dart';
import 'package:careshare/note_manager/cubit/notes_cubit.dart';
import 'package:careshare/note_manager/models/delta_data.dart';
import 'package:careshare/note_manager/models/note.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:uuid/uuid.dart';

class NoteDetailedView extends StatefulWidget {
  static const routeName = '/note-detailed-view';
  final Caregroup caregroup;
  final String noteId;

  const NoteDetailedView({
    required this.caregroup,
    required this.noteId,
    Key? key,
  }) : super(key: key);

  @override
  State<NoteDetailedView> createState() => _NoteDetailedViewState();
}

class _NoteDetailedViewState extends State<NoteDetailedView> {
  final _formKey = GlobalKey<FormState>();
  Timer? _debounce;
  bool _dirty = false;
  bool _firstTimeThrough = true;
  int _lastDeltaProcessed = 0;
  final String _deviceId = Uuid().v4();

  TextEditingController titleController = TextEditingController();
  quill.QuillController? quillController;
  FocusNode _focusNode = FocusNode();
  ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);

  @override
  void dispose() {
    titleController.dispose();
    quillController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        // print(state);
        if (state is NoteLoading) {
          return const //Text("loading note");
              LoadingPageTemplate(loadingMessage: 'Loading note...');
        }
        if (state is NoteError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is NoteLoaded) {
          Note _note = state.note;
          // print(_note.toString());

          titleController.text = _note.title;

          if (_firstTimeThrough) {
            quillController =
                quill.QuillController(document: _note.content!, selection: const TextSelection.collapsed(offset: 0));

            quillController!.document.changes.listen((event) async {
              // _dirty = true;
              // if (_debounce?.isActive ?? false) _debounce?.cancel();
              // _debounce = Timer(const Duration(milliseconds: 1000), () {
              final quill.Delta delta = event.item2;
              final quill.ChangeSource changeSource = event.item3;

              // only save my changes
              if (changeSource == quill.ChangeSource.LOCAL) {
                print("delta: ${event.item2}");
                print("source: ${event.item3}");

                DeltaData _deltaData =
                    DeltaData(delta: delta, deviceId: _deviceId, user: FirebaseAuth.instance.currentUser!.uid);
                BlocProvider.of<NoteCubit>(context).addDelta(_note.id, _deltaData);

                // BlocProvider.of<NotesCubit>(context).editNote(
                //   noteField: NoteField.content,
                //   note: _note,
                //   newValue: quillController!.document,
                //   // newValue: quill.Document.fromDelta(quillController!.document.toDelta()),
                // );
              }
              // });
            });

            _firstTimeThrough = false;
          } else {

            // process any new deltas
            _note.deltas.forEach((deltaData) {

              if (deltaData.deviceId != _deviceId && int.parse(deltaData.id) > _lastDeltaProcessed) {
                print("===========================================");
                print("deltaData.deviceId: ${deltaData.deviceId}");
                print("_deviceId: $_deviceId");
                print("int.parse(deltaData.id): ${int.parse(deltaData.id)}");
                print("_lastDeltaProcessed: $_lastDeltaProcessed");

                quillController!
                    .compose(deltaData.delta, const TextSelection.collapsed(offset: 0), quill.ChangeSource.REMOTE);
              }
              _lastDeltaProcessed = int.parse(deltaData.id);
            });

          }


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
                        final noteCubit = BlocProvider.of<NotesCubit>(context);

                        noteCubit.removeNote(_note.id);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                          BlocProvider.of<NotesCubit>(context).editNote(
                            noteField: NoteField.title,
                            note: _note,
                            newValue: value,
                          );
                        });
                      },
                      decoration: const InputDecoration(
                        disabledBorder: (OutlineInputBorder(borderSide: BorderSide(color: Colors.black38))),
                        label: Text('Title'),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        ProfilePhotoWidget(id: _note.createdById, size: 30),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                              "Created by: ${BlocProvider.of<AllProfilesCubit>(context).getName(_note.createdById)}"
                              "${_note.createdDate != null ? ' on ' : ''}"
                              "${_note.createdDate != null ? DateFormat('d MMM yyyy').add_jm().format(_note.createdDate) : ''}"),
                        ),
                      ],
                    ),
                    Expanded(
                      child: quill.QuillEditor(
                          controller: quillController!,
                          focusNode: _focusNode,
                          scrollController: _scrollController,
                          scrollable: true,
                          padding: EdgeInsets.all(0),
                          autoFocus: true,
                          readOnly: false,
                          expands: true),
                    ),
                    // quill.QuillEditor.basic(
                    //   controller: quillController!,
                    //   readOnly: false,
                    // ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: quill.QuillToolbar.basic(
                        controller: quillController!,
                        toolbarIconAlignment: WrapAlignment.start,
                      ),
                    ),
                  ],
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
