part of '../chat_part.dart';

class ChatMain extends StatelessWidget {
  ChatMain({Key? key, required this.state}) : super(key: key);

  final ChatLoadSuccess state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(state.room),
          actions: [
            IconButton(
              icon: Icon(Icons.notes),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ChatLog())),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.messages.length,
                  reverse: true,
                  itemBuilder: (context, index) =>
                      MessageBubble(message: state.messages[index]),
                ),
              ),
              MessageInput(
                isConnected: state.connectionStatus == ConnectionStatus.active,
                onMessageEntered: (text) =>
                    context.read<ChatBloc>().add(ChatMessageSent(text: text)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
