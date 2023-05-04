import 'dart:convert';

class UploadResponse {
  final List<String>? data;
  final bool success;

  UploadResponse({
    required this.data,
    required this.success,
  });

  factory UploadResponse.fromJson(Map<dynamic, dynamic> json) => UploadResponse(
        data: (json['data'] as List<dynamic>).cast<String>(),
        success: json['success'] as bool,
      );

  String toJson() => json.encode({
        'data': data,
        'success': success,
      });
}
