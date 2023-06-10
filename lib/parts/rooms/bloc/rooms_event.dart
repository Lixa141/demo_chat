part of '../rooms_part.dart';

abstract class RoomsEvent extends Equatable {
  const RoomsEvent();

  @override
  List<Object> get props => [];
}

class RoomsOpened extends RoomsEvent {
  final User user;

  RoomsOpened({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class RoomsFetched extends RoomsEvent {
  final User user;

  RoomsFetched({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class RoomsConnectionStatusChanged extends RoomsEvent {
  final ConnectionStatus connectionStatus;

  RoomsConnectionStatusChanged({
    required this.connectionStatus,
  });

  @override
  List<Object> get props => [connectionStatus];
}

class RoomsMessageReceived extends RoomsEvent {
  final Message message;

  RoomsMessageReceived({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
