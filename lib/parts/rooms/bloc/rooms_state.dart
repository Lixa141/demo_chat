part of '../rooms_part.dart';

abstract class RoomsState {
  const RoomsState();
}

class RoomsInitial extends RoomsState {}

class RoomsLoadSuccess extends RoomsState {
  final List<Room> rooms;
  final User user;
  final ConnectionStatus connectionStatus;

  RoomsLoadSuccess({
    required this.user,
    required this.rooms,
    required this.connectionStatus,
  });

  RoomsLoadSuccess copyWith({
    List<Room>? rooms,
    User? user,
    ConnectionStatus? connectionStatus,
  }) {
    return RoomsLoadSuccess(
      rooms: rooms ?? this.rooms,
      user: user ?? this.user,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }
}

class RoomsLoadFailed extends RoomsState {
  final User user;

  RoomsLoadFailed({
    required this.user,
  });
}
