import 'dart:convert';

import '../common/extensions.dart';
import 'login_response.dart';

class RefreshResponse {
  final Logindata? data;
  final bool success;

  RefreshResponse({required this.data, required this.success});

  factory RefreshResponse.fromJson(Map<dynamic, dynamic> json) {
    final dynamic data = json['data'];
    return RefreshResponse(
      data: data == null
          ? null
          : Logindata?.fromJson(data as Map<String, dynamic>),
      success: json['success'] as bool,
    );
  }

  factory RefreshResponse.empty() =>
      RefreshResponse(data: null, success: false);

  String toJson() => json.encode({
        'data': data?.toJson(),
        'success': success,
      });

  bool isValid() {
    return success && !data!.access_token.isNullOrBlank();
  }
}
