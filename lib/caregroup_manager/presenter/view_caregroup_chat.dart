import 'dart:io';

import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/chat_manager/cubit/chat_cubit.dart';
import 'package:careshare/chat_manager/models/chat.dart';
import 'package:careshare/chat_manager/models/chat_type.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:image_picker/image_picker.dart';

class ViewCaregroupChat extends StatefulWidget {
  static const routeName = '/view-caregroup-overview';
  final Caregroup caregroup;

  const ViewCaregroupChat({
    required this.caregroup,
    Key? key,
  }) : super(key: key);

  @override
  State<ViewCaregroupChat> createState() => _ViewCaregroupChatState();
}

class _ViewCaregroupChatState extends State<ViewCaregroupChat> {
  TextEditingController chatController = TextEditingController();

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;
    List<Profile> profileList = BlocProvider.of<AllProfilesCubit>(context).profileList;
    List<Chat> chatList = BlocProvider.of<ChatCubit>(context).chatList;

    BlocProvider.of<ChatCubit>(context).fetchChat(channelId: widget.caregroup.id);

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const //Text("loading chat");
              LoadingPageTemplate(loadingMessage: 'Loading chat...');
        }
        if (state is ChatError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is ChatLoaded) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      reverse: true,
                      itemCount: chatList.length,
                      itemBuilder: (context, index) => Row(
                            children: [
                              (chatList[index].fromProfileId != myProfile.id)
                                  ? Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(profileList
                                                .firstWhere((profile) => profile.id == chatList[index].fromProfileId)
                                                .photo),
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  : SizedBox(width: 35),
                              Expanded(
                                child: (chatList[index].type == ChatType.image)
                                    ? Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xFFE8E8EE),
                                              width: 3,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                image: NetworkImage(chatList[index].content), fit: BoxFit.scaleDown),
                                          ),
                                        ),
                                      )
                                    : BubbleSpecialThree(
                                        text: chatList[index].content,
                                        color: Color(0xFFE8E8EE),
                                        tail: true,
                                        isSender: (chatList[index].fromProfileId == myProfile.id)),
                              ),
                              (chatList[index].fromProfileId == myProfile.id)
                                  ? Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(profileList
                                                .firstWhere((profile) => profile.id == chatList[index].fromProfileId)
                                                .photo),
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  : SizedBox(width: 35),
                            ],
                          )),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            final imagePicker = ImagePicker();
                            final pickedImageFile = await imagePicker.pickImage(
                              // source: fromGallery ? ImageSource.gallery : ImageSource.camera,
                              source: ImageSource.camera,
                            );
                            if (pickedImageFile != null) {
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child('chat')
                                  .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');

                              await ref.putFile(File(pickedImageFile.path));
                              final url = await ref.getDownloadURL();

                              // save the chat
                              final chatCubit = BlocProvider.of<ChatCubit>(context);
                              await chatCubit.createChatRepository(widget.caregroup.id, url, ChatType.image);
                              chatController.clear();
                            }
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          // focusNode: focusNode,
                          textInputAction: TextInputAction.send,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          controller: chatController,
                          onSubmitted: (String value) async {
                            final chatCubit = BlocProvider.of<ChatCubit>(context);
                            await chatCubit.createChatRepository(widget.caregroup.id, value, ChatType.text);
                            chatController.clear();
                          },
                          // decoration:
                          // onSubmitted: (value) {
                          // onSendMessage(textEditingController.text, MessageType.text);
                          // },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            // onSendMessage(textEditingController.text, MessageType.text);
                            // add message to chat
                            if (chatController.text.length>0) {
                              final chatCubit = BlocProvider.of<ChatCubit>(context);
                              await chatCubit.createChatRepository(
                                  widget.caregroup.id, chatController.text, ChatType.text);
                              chatController.clear();
                            }
                          },
                          icon: const Icon(Icons.send_rounded),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
