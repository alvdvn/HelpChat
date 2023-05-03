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
