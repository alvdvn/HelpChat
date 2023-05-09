import 'package:json_annotation/json_annotation.dart';
class SeenResponse {
  final bool status;

  SeenResponse({
    required this.status
  });


  factory SeenResponse.fromJson(Map<dynamic, dynamic> json) => SeenResponse(
        status: json['status'] as bool

  );
}