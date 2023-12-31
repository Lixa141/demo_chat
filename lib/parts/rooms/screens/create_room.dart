part of '../rooms_part.dart';

class CreateRoom extends StatefulWidget {
  final User user;

  CreateRoom({
    required this.user,
  });

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final _formKey = GlobalKey<FormState>();
  var _roomName = '';

  void _tryCreate() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => RepositoryProvider.value(
                value: context.read<MessageRepository>(),
                child: BlocProvider(
                  create: (context) => ChatBloc(
                      messageRepository: context.read<MessageRepository>(),
                      room: _roomName,
                      user: widget.user,
                      chatRepository:
                          ChatRepository(chatDataProvider: ChatDataProvider()))
                    ..add(ChatFetched(isRoomNew: true)),
                  child: Chat(),
                ),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.l10n;

    return Scaffold(
        appBar: AppBar(
          title: Text(locale.createRoom),
        ),
        body: Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      autocorrect: true,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty || value.length < 3) {
                            return locale.createRoomHintOne;
                          } else if (value.length > 20)
                            return locale.createRoomHintTwo;
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: locale.roomName),
                      onSaved: (value) {
                        _roomName = value ?? '';
                      },
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      child: Text(locale.createRoom),
                      onPressed: _tryCreate,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
