part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatUpdating extends ChatState {
  const ChatUpdating();
}

class ChatLoaded extends ChatState {
  final List<Chat> chatList;
  
  const ChatLoaded({
    required this.chatList,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatLoaded && listEquals(other.chatList, chatList);
  }

  @override
  int get hashCode => chatList.hashCode;
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
