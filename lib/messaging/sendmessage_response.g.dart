part of 'sendmessage_response.dart';

SendMessageResponse _$sendMessageResponseFromJson(Map<String, dynamic> json) =>
    SendMessageResponse(
      status: json['status'] as bool,
      message: Message.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$sendMessageResponsetoJson(SendMessageResponse intance) =>
    <String, dynamic>{'status': intance.status, 'message': intance.message};
