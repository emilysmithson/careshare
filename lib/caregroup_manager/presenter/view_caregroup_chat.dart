import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/chat_manager/cubit/chat_cubit.dart';
import 'package:careshare/chat_manager/models/chat.dart';
import 'package:careshare/chat_manager/models/chat_type.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_bubbles/chat_bubbles.dart';


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
          return const LoadingPageTemplate(
              loadingMessage: 'Loading chat...');
        }
        if (state is ChatError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is ChatLoaded) {


          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                SizedBox(
                  height: 550,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    reverse: true,
                    itemCount: chatList.length,
                    itemBuilder: (context, index) =>
                      (chatList[index].fromProfileId != myProfile.id)
                          ? Row(
                            children: [
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          profileList.firstWhere((profile) => profile.id == chatList[index].fromProfileId).photo
                                      ), fit: BoxFit.cover),
                                ),
                              ),
                              Expanded(
                                child: BubbleSpecialThree(
                                text: chatList[index].content,
                                color: Color(0xFFE8E8EE),
                                tail: true,
                                isSender: false,
                              ),
                              ),
                              SizedBox(width: 40),
                            ],
                          )
                        : Row(
                            children: [
                              SizedBox(width: 40),
                              Expanded(
                                child: BubbleSpecialThree(
                                  text: chatList[index].content,
                                  color: Color(0x558ec8f7),
                                  tail: true,
                                  isSender: true,
                                ),
                              ),
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                image: NetworkImage(
                                    profileList.firstWhere((profile) => profile.id == chatList[index].fromProfileId).photo
                                ), fit: BoxFit.cover),
                          ),
                        ),
                      ],
                      ),


                  ),
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
                          onPressed: ()  {},
                          icon: const Icon(
                            Icons.camera_alt,
                            // size: 28,
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
                            // decoration:
                            // kTextInputDecoration.copyWith(hintText: 'write here...'),
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
                            final chatCubit = BlocProvider.of<ChatCubit>(context);
                            final Chat chat =await chatCubit.createChatRepository(
                                widget.caregroup.id,
                                chatController.text,
                                ChatType.text
                            );
                            chatController.clear();

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
