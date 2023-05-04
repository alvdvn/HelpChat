part of 'message_response.dart';

RoomData _$roomDataFromJson(Map<String, dynamic> json) => RoomData(
    id: json['id'] ?? 0 as int,
    name: json['name'] ?? "" as String,
    created_at: json['created_at'] ?? "" as String,
    updated_at: json['updated_at'] ?? "" as String,
    message: ((json['messages'] ?? []) as List<dynamic>)
        .map((e) => Message.fromJson(e as Map<String, dynamic>))
        .toList());

Map<String, dynamic> _$roomDataToJson(RoomData intance) => <String, dynamic>{
      'id': intance.id,
      'name': intance.name,
      'created_at': intance.created_at,
      'updated_at': intance.updated_at,
      'messages': intance.message
    };

Message _$messageFromjson(Map<String, dynamic> json) => Message(
    id: json['id'] ?? 0 as int,
    room_id: json['room_id'] ?? 0 as int,
    from_id: json['from_id'] ?? '' as String,
    message: json['message'] ?? '' as String,
    seen: json['seen'] ?? 0 as int,
    created_at: json['created_at'] ?? '' as String,
    updated_at: json['updated_at'] ?? '' as String,
    from: User.fromJson((json['from'] ?? {})));

Map<String, dynamic> _$messageTojson(Message intance) => <String, dynamic>{
      'id': intance.id,
      'room_id': intance.room_id,
      'from_id': intance.from_id,
      'message': intance.message,
      'seen': intance.seen,
      'created_at': intance.created_at,
      'updated_at': intance.updated_at,
      'from': intance.from
    };
