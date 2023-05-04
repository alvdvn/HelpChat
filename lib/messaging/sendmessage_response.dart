import 'message_response.dart';

part 'sendmessage_response.g.dart';

class SendMessageResponse {
  bool status;
  Message message;

  SendMessageResponse({required this.status, required this.message});

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$sendMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$sendMessageResponsetoJson(this);
}
