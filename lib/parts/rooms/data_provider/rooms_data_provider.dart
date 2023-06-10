part of '../rooms_part.dart';

class RoomsDataProvider {
  Future<Map<String, dynamic>> downloadRooms() async {
    final response = await Dio().get(
      'https://nane.tada.team/api/rooms',
    );
    return response.data!;
  }
}
