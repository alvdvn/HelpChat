import 'sendmessage_response.dart';
import 'upload_response.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'message_response.dart';

class MessagesRepository {
  final Dio _dio;

  MessagesRepository(Dio dio) : _dio = dio;

  Future<List<Message>> fetchMessages(String channel) async {
    String path = '/chat/$channel';
    try {
      final response = await _dio.get<Map>(path);
      final data = response.data;
      if (data == null) return <Message>[];

      return MessageResponse.fromJson(data).data!.message;
    } catch (e) {
      return <Message>[];
    }
  }

  Future<SendMessageResponse> sendMessage(
      String message, String channel) async {
    String path = '/chat/$channel';

    var param = <String, dynamic>{'message': message};
    final response = await _dio.post<Map>(path, data: param);
    final data = response.data as Map<String, dynamic>;

    return SendMessageResponse.fromJson(data);
  }

  Future<List<String>?> _uploadImages(List<XFile>? images) async {
    if (images == null || images.isEmpty) return null;

    const path = '/api/auth/msg/upload';
    final fileFutures = images.map((e) async =>
        MultipartFile.fromBytes(await e.readAsBytes(), filename: e.name));

    final files = await Future.wait(fileFutures);
    final data = FormData.fromMap(<String, dynamic>{'files': files});
    final response = await _dio.post<Map>(path, data: data);
    return UploadResponse.fromJson(response.data!).data;
  }
}
