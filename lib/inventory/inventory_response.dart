import 'dart:convert';

class InventoryResponse {
  final List<String> data;
  final bool success;

  InventoryResponse({required this.data, required this.success});

  factory InventoryResponse.fromJson(Map<dynamic, dynamic> json) {
    final dynamic data = json['data'];
    return InventoryResponse(
      data: data == null ? <String>[] : (json['data'] as List<dynamic>).cast(),
      success: json['success'] as bool,
    );
  }

  String toJson() => json.encode({'data': data, 'success': success});
}
