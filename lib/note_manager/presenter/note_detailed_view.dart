import 'dart:async';

import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/note_manager/cubit/note_cubit.dart';
import 'package:careshare/note_manager/models/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';

class NoteDetailedView extends StatefulWidget {
  static const String routeName = "/note-detailed-view";
  final Note note;

  const NoteDetailedView({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  State<NoteDetailedView> createState() => _NoteDetailedViewState();
}

class _NoteDetailedViewState extends State<NoteDetailedView> {
  final _formKey = GlobalKey<FormState>();
  Timer? _debounce;
  TextEditingController titleController = TextEditingController();

  quill.QuillController? _controller;


  final FocusNode _focusNode = FocusNode();

  bool _dirty = false;

  @override
  void initState() {
    titleController.text = widget.note.title;
    _controller =
        quill.QuillController(document: widget.note.content!, selection: const TextSelection.collapsed(offset: 0));

    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    titleController.dispose();
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Note originalNote = widget.note.clone();

    // Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;
    Caregroup _caregroup =
        BlocProvider.of<CaregroupCubit>(context).myCaregroupList.firstWhere((c) => c.id == widget.note.caregroupId);


    _controller!.document.changes.listen((event) async {
      _dirty = true;
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 100), () {

        print(_controller!.document.toDelta().toJson());

        BlocProvider.of<NoteCubit>(context).editNote(
          noteField: NoteField.content,
          note: widget.note,
          newValue: quill.Document.fromDelta(_controller!.document.toDelta()),
        );
      });
    });

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Scaffold(
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button
                  // Shown when the note is in Draft
                  // When clicked, the draft note is deleted

                  // Cancel Button
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<NoteCubit>(context).removeNote(widget.note.id);

                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),

                  // Undo button
                  // Shown when _dirty is true
                  // When clicked, the note is reverted
                  if (_dirty)
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<NoteCubit>(context).updateNote(originalNote);

                        Navigator.pop(context);
                      },
                      child: const Text('Undo Changes'),
                    ),

                  // Create Note button
                  // Shown when the note is in Draft
                  // When clicked, the status is set to:
                  //    Created if note isn't assigned
                  //    Assigned if the note is assigned to someone else
                  //    Accepted if the note is assigned to me
                  // A message is sent to everyone in the caregroup except me if the note is unassigned
                  // A message is sent to the assignee if the note is assigned
                  ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        print('validation failed');
                      } else {
                        // BlocProvider.of<NoteCubit>(context).createNote(
                        //   note: widget.note,
                        //   profileId: myProfile.id,
                        // );
                        //
                        Navigator.pop(context);
                        //
                        // // Send a message to tell the world the note is created
                        // final String id = DateTime.now().millisecondsSinceEpoch.toString();
                        // final DateTime dateTime = DateTime.now();
                        //
                        // final completionNotification = CareshareNotification(
                        //     id: id,
                        //     caregroupId: widget.note.caregroupId,
                        //     title: "${myProfile.displayName} has created a new note: '${widget.note.title}'",
                        //     routeName: "/note-detailed-view",
                        //     subtitle: 'on ${DateFormat('E d MMM yyyy').add_jm().format(dateTime)}',
                        //     dateTime: dateTime,
                        //     senderId: myProfile.id,
                        //     isRead: false,
                        //     arguments: widget.note.id);
                        //
                        // // send to everyone in the caregroup except me
                        // List<String> recipientIds = [];
                        // List<String> recipientTokens = [];
                        // BlocProvider.of<AllProfilesCubit>(context).profileList.forEach((p) {
                        //   if (p.id != myProfile.id &&
                        //       p.carerInCaregroups
                        //               .indexWhere((element) => element.caregroupId == widget.note.caregroupId) !=
                        //           -1) {
                        //     recipientIds.add(p.id);
                        //     recipientTokens.add(p.messagingToken);
                        //   }
                        // });
                        //
                        // BlocProvider.of<NotificationsCubit>(context).sendNotifications(
                        //   notification: completionNotification,
                        //   recipientIds: recipientIds,
                        //   recipientTokens: recipientTokens,
                        // );
                      }
                    },
                    child: const Text('Create Note'),
                  ),
                ],
              ),
              appBar: AppBar(
                title: const Text('Note Details'),
                actions: [
                  if (_caregroup.test)
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
                      quill.QuillToolbar.basic(controller: _controller!),
                      quill.QuillEditor.basic(
                        controller: _controller!,
                        readOnly: false, // true for view only mode
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
