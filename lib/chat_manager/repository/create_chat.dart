import 'package:careshare/chat_manager/models/chat_type.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/chat.dart';

import 'package:firebase_auth/firebase_auth.dart';

class CreateChat {
  Future<Chat> call(
      String channelId,
      String content,
      ChatType type,
      ) async {
    final chat = Chat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      channelId: channelId,
      fromProfileId: FirebaseAuth.instance.currentUser!.uid,
      timeStamp: DateTime.now(),
      content: content,
      type: type,
    );
    DatabaseReference reference = FirebaseDatabase.instance.ref('chats');

    reference.child(chat.id).set(chat.toJson());

    return chat;
  }
}
