import 'package:dio/dio.dart';

import 'channel_response.dart';

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
}
