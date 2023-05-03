// ignore_for_file: non_constant_identifier_names


import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';
part 'login_response.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponse {
  bool? status;
  String? message;
  Logindata? logindata;


  LoginResponse({
    required this.status,
    required this. message,
    required this.logindata

  });

  factory LoginResponse.fromJson(Map<dynamic,dynamic> json) =>
      _$loginResponseFromjson(json);
  Map<String,dynamic> toJson() => _$loginResponseToJson(this);
}
class Logindata{
  String access_token;
  String? token_type;
  int? expires_in;
  User user;
  Logindata({
    required this.access_token,
    required this.token_type,
    required this.expires_in,
    required this.user
  });

  factory Logindata.fromJson(Map<String,dynamic> json) =>
      _$loginDataFromjson(json);
  Map<String,dynamic> toJson() => _$loginDataToJson(this);
}

