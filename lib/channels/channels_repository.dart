import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'channel_response.dart';
import 'seen_resnponse.dart';

class ChannelsRepository {
  final Dio _dio;

  ChannelsRepository(Dio dio) : _dio = dio;

  Future<List<Channel>> fetchChannels() async {
    const path = '/chat';
    try {
      final response = await _dio.get<Map>(path);
      final data = response.data;
      if (data == null) return <Channel>[];

      return ChannelResponse.fromJson(data).data ?? <Channel>[];
    } catch (e) {
      return <Channel>[];
    }
  }
  Future<bool> putSeen(String param) async{
    String path ='/chat/$param';
    try{
      final response= await _dio.put<Map>(path);
      final data = response.data;
      if(data == null ) return false;
      return SeenResponse.fromJson(data).status ?? false;
    }catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
