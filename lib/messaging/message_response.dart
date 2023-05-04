import 'dart:convert';
import '../auth/user_model.dart';

part 'message_response.g.dart';

class MessageResponse {
  final RoomData data;
  final bool success;

  MessageResponse({
    required this.data,
    required this.success,
  });

  factory MessageResponse.fromJson(Map<dynamic, dynamic> json) =>
      MessageResponse(
        data: RoomData.fromJson(json['data'] as Map<String, dynamic>),
        success: json['status'] as bool,
      );

  String toJson() => json.encode({
        'data': data,
        'status': success,
      });
}

class Message {
  int id;
  int room_id;
  String from_id;
  String message;
  int seen;
  String created_at;
  String updated_at;
  User from;

  Message(
      {required this.id,
      required this.room_id,
      required this.from_id,
      required this.message,
      required this.seen,
      required this.created_at,
      required this.updated_at,
      required this.from});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$messageFromjson(json);

  Map<String, dynamic> toJson() => _$messageTojson(this);
}

class RoomData {
  int id;
  String name;
  String created_at;
  String updated_at;
  List<Message> message;

  RoomData(
      {required this.id,
      required this.name,
      required this.created_at,
      required this.updated_at,
      required this.message});

  factory RoomData.fromJson(Map<String, dynamic> json) =>
      _$roomDataFromJson(json);

  Map<String, dynamic> toJson() => _$roomDataToJson(this);
}

// enum MessageStatus { sending, sent, failed }
