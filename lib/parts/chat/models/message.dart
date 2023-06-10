part of '../chat_part.dart';

Message parseMessage(Map<String, dynamic> messageJson, String username) {
  if (messageJson['sender'] != null &&
      messageJson['sender']['username'] == username)
    return UserMessage.fromJson(messageJson);
  else
    return ReceivedMessage.fromJson(messageJson);
}

abstract class Message extends Equatable {
  final String room;
  final String created;
  final Sender sender;
  final String text;

  Message({
    required this.room,
    required this.created,
    required this.sender,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['room'] = this.room;
    data['created'] = this.created;
    data['sender'] = this.sender.toJson();
    data['text'] = this.text;
    return data;
  }

  @override
  List<Object> get props => [room, created, sender, text];

  @override
  String toString() {
    return 'Message{room: $room, created: $created, text: $text}';
  }
}

class ReceivedMessage extends Message {
  ReceivedMessage({
    required String room,
    required String created,
    required Sender sender,
    required String text,
  }) : super(room: room, created: created, sender: sender, text: text);

  factory ReceivedMessage.fromJson(Map<String, dynamic> json) {
    return ReceivedMessage(
      room: json['room'],
      created: json['created'],
      sender: json['sender'] != null
          ? Sender.fromJson(json['sender'])
          : Sender(username: 'DEFAULT'),
      text: json['text'],
    );
  }
}

class UserMessage extends Message {
  final bool isSent;

  UserMessage({
    required String room,
    required String created,
    required Sender sender,
    required String text,
    this.isSent = false,
  }) : super(room: room, created: created, sender: sender, text: text);

  factory UserMessage.fromJson(Map<String, dynamic> json) {
    return UserMessage(
      isSent: true,
      room: json['room'],
      created: json['created'],
      sender: json['sender'] != null
          ? Sender.fromJson(json['sender'])
          : Sender(username: 'DEFAULT'),
      text: json['text'],
    );
  }

  UserMessage copyWith({
    bool? isSent,
  }) {
    return UserMessage(
      isSent: isSent ?? this.isSent,
      room: room,
      created: created,
      sender: sender,
      text: text,
    );
  }
}

class Sender extends Equatable {
  final String username;

  Sender({required this.username});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['username'] = this.username;
    return data;
  }

  @override
  List<Object> get props => [username];
}
