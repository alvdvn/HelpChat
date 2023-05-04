import 'dart:convert';

import '../auth/user_model.dart';

class ChannelResponse {
  final List<Channel>? data;
  final bool success;

  ChannelResponse({
    required this.data,
    required this.success,
  });

  factory ChannelResponse.fromJson(Map<dynamic, dynamic> json) =>
      ChannelResponse(
        data: json['data'] == null
            ? null
            : List<Channel>.from((json['data'] as List<dynamic>)
                .cast<Map<String, dynamic>>()
                .map<Channel>((x) => Channel.fromJson(x))),
        success: json['status'] as bool,
      );

  String toJson() => json.encode({
        'data': data?.toString(),
        'status': success,
      });
}

class Channel {
  final int id;
  final String name;
  final String create_at;
  final String update_at;
  final Pivot pivot;

  Channel({
    required this.id,
    required this.name,
    required this.create_at,
    required this.update_at,
    required this.pivot,

  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
      id: json['id'] as int,
      name: json['name'] as String,
      create_at: json['created_at'] as String,
      update_at: json['updated_at']  as String,
      pivot: Pivot.fromJson(json['pivot'] as Map<String, dynamic>)
  );

}

class Pivot {
  final int member_id;
  final int room_id;


  Pivot({required this.member_id, required this.room_id});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      member_id: json['member_id'] as int,
  room_id: json['room_id'] as int
  );

  }
}
