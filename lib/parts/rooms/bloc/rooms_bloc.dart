part of '../rooms_part.dart';

class RoomsBloc extends HydratedBloc<RoomsEvent, RoomsState> {
  final RoomsRepository roomsRepository;
  final MessageRepository messageRepository;
  StreamSubscription? messageSubscription;
  StreamSubscription? connectionStatusSubscription;

  RoomsBloc(
      {required this.roomsRepository,
      required this.messageRepository,
      this.messageSubscription,
      this.connectionStatusSubscription})
      : super(RoomsInitial()) {
    on(_onRoomsOpened);
    on(_onRoomsFetched);
    on(_onRoomsConnectionStatusChanged);
    on(_onRoomsMessageReceived);

    messageSubscription = messageRepository.messageStream.listen(
      (event) => add(RoomsMessageReceived(message: event)),
    );
    connectionStatusSubscription = messageRepository.connectionStatusStream
        .distinct()
        .listen((event) =>
            add(RoomsConnectionStatusChanged(connectionStatus: event)));
  }

  Future<void> _onRoomsOpened(
    RoomsOpened event,
    Emitter<RoomsState> emit,
  ) async {
    if (state is! RoomsLoadSuccess) {
      add(RoomsFetched(user: event.user));
    }
  }

  Future<void> _onRoomsFetched(
    RoomsFetched event,
    Emitter<RoomsState> emit,
  ) async {
    try {
      List<Room> rooms = await roomsRepository.downloadRooms();
      rooms.sort((a, b) => a.message != null
          ? -a.message!.created.compareTo(b.message?.created ?? '')
          : 0);
      emit(RoomsLoadSuccess(
          user: event.user,
          rooms: rooms,
          connectionStatus: ConnectionStatus.active));
    } catch (e) {
      print(e);
      emit(RoomsLoadFailed(user: event.user));
    }
  }

  Future<void> _onRoomsConnectionStatusChanged(
    RoomsConnectionStatusChanged event,
    Emitter<RoomsState> emit,
  ) async {
    if (state is RoomsLoadSuccess) {
      final stateLocal = state as RoomsLoadSuccess;
      emit(stateLocal.copyWith(connectionStatus: event.connectionStatus));
      if (event.connectionStatus == ConnectionStatus.active)
        add(RoomsFetched(user: (state as RoomsLoadSuccess).user));
    } else if (state is RoomsLoadFailed) {
      if (event.connectionStatus == ConnectionStatus.active)
        add(RoomsFetched(user: (state as RoomsLoadFailed).user));
    }
  }

  Future<void> _onRoomsMessageReceived(
    RoomsMessageReceived event,
    Emitter<RoomsState> emit,
  ) async {
    if (state is RoomsLoadSuccess) {
      final stateLocal = state as RoomsLoadSuccess;
      List<Room> rooms = List.from((state as RoomsLoadSuccess).rooms);
      rooms.add(Room(name: event.message.room, message: event.message));
      rooms.sort((a, b) => a.message != null
          ? -a.message!.created.compareTo(b.message?.created ?? '')
          : 0);
      emit(stateLocal.copyWith(rooms: rooms));
    }
  }

  @override
  RoomsState fromJson(Map<String, dynamic> json) {
    return RoomsLoadSuccess(
        user: User.fromJson(json['user']),
        rooms: (json['rooms'] as List).map((e) => Room.fromJson(e)).toList(),
        connectionStatus: ConnectionStatus.values
            .firstWhere((element) => element.toString() == json['connection']));
  }

  @override
  Map<String, dynamic>? toJson(RoomsState state) {
    if (state is RoomsLoadSuccess)
      return {
        'user': state.user.toJson(),
        'rooms': state.rooms.map((e) => e.toJson()).toList(),
        'connection': state.connectionStatus.toString()
      };
    else
      return null;
  }

  @override
  Future<void> close() {
    messageRepository.dispose();
    messageSubscription?.cancel();
    connectionStatusSubscription?.cancel();
    return super.close();
  }
}
