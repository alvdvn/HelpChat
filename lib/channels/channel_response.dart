// Copyright (c) 2023 Razeware LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
// distribute, sublicense, create a derivative work, and/or sell copies of the
// Software in any work that is designed, intended, or marketed for pedagogical
// or instructional purposes related to programming, coding, application
// development, or information technology.  Permission for such use, copying,
// modification, merger, publication, distribution, sublicensing, creation of
// derivative works, or sale is expressly withheld.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
