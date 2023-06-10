part of '../chat_part.dart';

class ChatRepository {
  final ChatDataProvider chatDataProvider;

  ChatRepository({required this.chatDataProvider});

  Future<List<Message>> downloadChatHistory(
      String username, String room) async {
    Map<String, dynamic> json =
        await chatDataProvider.downloadChatHistory(room);
    if (json['result'] != null)
      return (json['result'] as List)
          .map((e) => parseMessage(e, username))
          .toList();
    else
      return [];
  }
}
