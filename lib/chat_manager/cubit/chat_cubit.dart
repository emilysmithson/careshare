import 'package:bloc/bloc.dart';
import 'package:careshare/chat_manager/models/chat.dart';
import 'package:careshare/chat_manager/models/chat_type.dart';
import 'package:careshare/chat_manager/repository/create_chat.dart';
import 'package:careshare/chat_manager/repository/remove_chat.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final CreateChat createChatRepository;
  final RemoveChat removeChatRepository;

  ChatCubit({
    required this.createChatRepository,
    required this.removeChatRepository,
  }) : super(const ChatInitial());

  final List<Chat> chatList = [];

  Future fetchChat({required String channelId}) async {
    try {
      print('.....fetching chat for: $channelId');

      emit(const ChatLoading());

      final reference = FirebaseDatabase.instance.ref('chats').orderByChild('channel').equalTo(channelId);
      final response = reference.onValue;
      response.listen((event) {
        emit(const ChatLoading());
        if (event.snapshot.value == null) {
          emit(
            ChatLoaded(
              chatList: chatList,
            ),
          );
        } else {
          Map<dynamic, dynamic> returnedList = event.snapshot.value as Map<dynamic, dynamic>;

          chatList.clear();
          returnedList.forEach(
            (key, value) {
              chatList.add(Chat.fromJson(key, value));
            },
          );
          chatList.sort(
            (a, b) => b.timeStamp.compareTo(a.timeStamp),
          );

          emit(
            ChatLoaded(
              chatList: chatList,
            ),
          );
        }
      });
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }

  Future<Chat?> createChat(String channelId, String content, String link, ChatType type) async {
    Chat? chat;
    try {
      chat = await createChatRepository(channelId, content, link, type);

      return chat;
    } catch (e) {
      emit(ChatError(e.toString()));
    }
    if (chat == null) {
      emit(
        const ChatError('Something went wrong, chat is null'),
      );
    }
    return null;
  }

  removeChat(String id) {
    emit(const ChatLoading());
    removeChatRepository(id);
    chatList.removeWhere((element) => element.id == id);

    emit(
      ChatLoaded(
        chatList: chatList,
      ),
    );
  }

  showChatDetails(Chat chat) {
    emit(
      ChatLoaded(
        chatList: chatList,
      ),
    );
  }

  showChatsOverview() {
    emit(
      ChatLoaded(
        chatList: chatList,
      ),
    );
  }

  Chat? fetchChatFromID(String id) {
    return chatList.firstWhereOrNull((element) => element.id == id);
  }
}
