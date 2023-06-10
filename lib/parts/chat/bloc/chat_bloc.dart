part of '../chat_part.dart';

const String greetingsText = 'Всем чмоки в этом чате!';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required this.room,
    required this.user,
    required this.chatRepository,
    required this.messageRepository,
  }) : super(ChatInitial()) {
    on(_onChatFetched);
    on(_onChatMessageSent);
    on(_onChatMessageReceived);
    on(_onChatConnectionStatusChanged);

    messageSubscription = messageRepository.messageStream
        .where((message) => message.room == room)
        .listen(
          (event) => add(ChatMessageReceived(message: event)),
        );
    connectionStatusSubscription = messageRepository.connectionStatusStream
        .listen((event) => add(ChatConnectionStatusChanged(status: event)));
  }

  final String room;
  final User user;
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;
  StreamSubscription? messageSubscription;
  StreamSubscription? connectionStatusSubscription;

  Future<void> _onChatFetched(
    ChatFetched event,
    Emitter<ChatState> emit,
  ) async {
    ChatLogger().memoryOutput.buffer.clear();
    ChatLogger().logger.i('чат $room открыт');
    var history = event.isRoomNew ? <Message>[] : await _downloadChatHistory();

    emit(ChatLoadSuccess(
        connectionStatus: ConnectionStatus.active,
        room: room,
        messages: history,
        user: user));
    if (event.isRoomNew) add(ChatMessageSent(text: greetingsText));
  }

  Future<void> _onChatMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoadSuccess) {
      final userMessage = UserMessage(
          created: DateTime.now().toString(),
          sender: Sender(username: user.username),
          text: event.text,
          room: room);
      ChatLogger().logger.i('отправка сообщения ${userMessage.text}');
      messageRepository.sendMessage(userMessage);
      final stateLocal = state as ChatLoadSuccess;
      emit(stateLocal.copyWith(messages: [
        ...[userMessage],
        ...stateLocal.messages
      ]));
    }
  }

  Future<void> _onChatMessageReceived(
    ChatMessageReceived event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoadSuccess) {
      final stateLocal = state as ChatLoadSuccess;
      ChatLogger().logger.i('получение сообщения  ${event.message.text}');
      emit(stateLocal.copyWith(messages: [
        ...[event.message],
        ...stateLocal.messages
      ]));
    }
  }

  Future<void> _onChatConnectionStatusChanged(
    ChatConnectionStatusChanged event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoadSuccess) {
      final stateLocal = state as ChatLoadSuccess;
      if (event.status == ConnectionStatus.active) {
        if (stateLocal.connectionStatus == ConnectionStatus.connecting) {
          var newMessages = [];
          final chatHistory = await _downloadChatHistory();
          if (chatHistory.isNotEmpty) {
            if (stateLocal.messages
                .any((element) => element.created.isNotEmpty))
              newMessages = chatHistory
                  .where((element) => DateTime.parse(element.created).isAfter(
                      DateTime.parse(stateLocal.messages
                          .firstWhere((element) => element.created.isNotEmpty)
                          .created)))
                  .toList();
            else
              newMessages = chatHistory;
          }
          if (newMessages.isNotEmpty)
            emit(stateLocal
                .copyWith(messages: [...newMessages, ...stateLocal.messages]));
        }
        var pendingUserMessages = stateLocal.messages
            .where((element) => element is UserMessage && !element.isSent)
            .toList();
        while (pendingUserMessages.isNotEmpty) {
          messageRepository.sendMessage(pendingUserMessages.removeLast());
        }
      }
      emit(stateLocal.copyWith(connectionStatus: event.status));
    }
  }

  Future<List<Message>> _downloadChatHistory() async {
    var history = <Message>[];
    try {
      history = await chatRepository.downloadChatHistory(user.username, room);
      history = history.reversed.toList();
    } catch (e) {
      ChatLogger().logger.i("ошибка при загрузке истории: $e");
      history.add(ReceivedMessage(
          room: room,
          created: DateTime.now().toString(),
          sender: Sender(username: "System"),
          text: "ошибка при загрузке истории: $e"));
    }
    return history;
  }

  @override
  Future<void> close() {
    messageSubscription?.cancel();
    connectionStatusSubscription?.cancel();
    return super.close();
  }
}
