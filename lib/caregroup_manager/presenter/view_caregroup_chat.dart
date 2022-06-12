import 'dart:io';

import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/chat_manager/cubit/chat_cubit.dart';
import 'package:careshare/chat_manager/models/chat.dart';
import 'package:careshare/chat_manager/models/chat_type.dart';
import 'package:careshare/chat_manager/presenter/chat_bubble.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/notification_manager/presenter/widgets/bell_widget.dart';
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
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(widget.caregroup.name),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              elevation: 0,
              toolbarHeight: 40,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                  },
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
            body: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        reverse: true,
                        itemCount: chatList.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            if (index==chatList.length-1
                        || chatList[index+1].timeStamp.year != chatList[index].timeStamp.year
                        || chatList[index+1].timeStamp.month != chatList[index].timeStamp.month
                        || chatList[index+1].timeStamp.day != chatList[index].timeStamp.day)
                                // DateFormat('yyyy-MM-dd').format(chatList[index-1].timeStamp)  != DateFormat('yyyy-MM-dd').format(chatList[index].timeStamp))
                              DateChip(date: chatList[index].timeStamp),
                            Row(
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
                                        : const SizedBox(width: 35),
                                    Expanded(
                                      child: (chatList[index].type == ChatType.image)
                                          ? Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          contentPadding: EdgeInsets.zero,
                                                          actionsAlignment: MainAxisAlignment.center,

                                                          content: Container(
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: const Color(0xFFE8E8EE),
                                                                width: 3,
                                                              ),
                                                              borderRadius: BorderRadius.circular(2),
                                                              shape: BoxShape.rectangle,
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      (chatList[index].link != null) ? chatList[index].link! : chatList[index].content),
                                                                  fit: BoxFit.cover),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Container(
                                                  height: 200,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color(0xFFE8E8EE),
                                                      width: 3,
                                                    ),
                                                    borderRadius: BorderRadius.circular(12),
                                                    shape: BoxShape.rectangle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(chatList[index].content), fit: BoxFit.scaleDown),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : ChatBubble(
                                              text: chatList[index].content,
                                              time: chatList[index].timeStamp, //TimeOfDay(hour: chatList[index].timeStamp.hour, minute: chatList[index].timeStamp.minute),
                                              color: const Color(0xFFE8E8EE),
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
                                        : const SizedBox(width: 35),
                                  ],
                                ),
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
                          child: PopupMenuButton(
                            tooltip: 'image',
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onSelected: (value) async {
                              // acquire image
                              final _image = await ImagePicker().pickImage(
                                source: (value == "camera") ? ImageSource.camera : ImageSource.gallery,
                              );

                              if (_image != null) {
                                final filePath = File(_image.path).absolute.path;

                                // create thumbnail
                                // Create output file path
                                // eg:- "Volume/VM/abcd_out.jpeg"
                                final imageName = "${myProfile.id}_${DateTime.now().millisecondsSinceEpoch.toString()}";
                                final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
                                final splitted = filePath.substring(0, (lastIndex));
                                final thumbnailPath = "${splitted}_thumb${filePath.substring(lastIndex)}";

                                // var result = await FlutterImageCompress.compressAndGetFile(
                                //   filePath,
                                //   thumbnailPath,
                                //   quality: 5,
                                // );

                                // store thumbnail image
                                final thumbnailRef = FirebaseStorage.instance
                                    .ref()
                                    .child('chat')
                                    .child(widget.caregroup.id)
                                    .child(DateTime.now().year.toString().padLeft(4, '0'))
                                    .child(DateTime.now().month.toString().padLeft(2, '0'))
                                    .child(DateTime.now().day.toString().padLeft(2, '0'))
                                    .child(imageName + '_thumb.jpg');
                                await thumbnailRef.putFile(File(thumbnailPath));
                                final thumbnailUrl = await thumbnailRef.getDownloadURL();

                                // store full size image
                                final ref = FirebaseStorage.instance
                                    .ref()
                                    .child('chat')
                                    .child(widget.caregroup.id)
                                    .child(DateTime.now().year.toString().padLeft(4, '0'))
                                    .child(DateTime.now().month.toString().padLeft(2, '0'))
                                    .child(DateTime.now().day.toString().padLeft(2, '0'))
                                    .child(imageName + '.jpg');
                                await ref.putFile(File(_image.path));
                                final imageUrl = await ref.getDownloadURL();

                                // save the chat
                                final chatCubit = BlocProvider.of<ChatCubit>(context);
                                await chatCubit.createChatRepository(widget.caregroup.id, thumbnailUrl, imageUrl, ChatType.image);
                                chatController.clear();

                              }
                            },
                            itemBuilder: (BuildContext bc) {
                              return const [
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.camera_alt), // your icon
                                    title: Text("camera"),
                                  ),
                                  value: "camera",
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.photo_library), // your icon
                                    title: Text("gallery"),
                                  ),
                                  value: "gallery",
                                ),
                              ];
                            },
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
                              await chatCubit.createChatRepository(widget.caregroup.id, value, "", ChatType.text);
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
                              if (chatController.text.isNotEmpty) {
                                final chatCubit = BlocProvider.of<ChatCubit>(context);
                                await chatCubit.createChatRepository(
                                    widget.caregroup.id, chatController.text, "", ChatType.text);
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
            ),
          );
        }
        return Container();
      },
    );
  }
}
