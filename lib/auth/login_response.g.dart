// ignore_for_file: unnecessary_cast

part of 'login_response.dart';



LoginResponse _$loginResponseFromjson(Map<dynamic,dynamic> json) =>
    LoginResponse(
        status: json['status'] as bool,
        message: json['message']?? '' as String,
        logindata: Logindata.fromJson((json['data']??{}))
    );

Map<String,dynamic> _$loginResponseToJson(LoginResponse intance) =>
    <String,dynamic>{
        'status': intance.status,
        'message': intance.message,
         'data'  :intance.logindata
};


Logindata _$loginDataFromjson(Map<String, dynamic> json) =>
    Logindata(
        access_token: json['access_token'] ??''as String,
        token_type:json['token_type'] ?? '' as String,
        expires_in: json['expires_in'] ?? 0 as int,
        user: User.fromJson((json['user'] ??{}))
    );

Map<String, dynamic> _$loginDataToJson(Logindata intance) =>
    <String, dynamic>{
      'access_token': intance.access_token,
      'token_type': intance.token_type,
      'expires_in' : intance.expires_in,
      'user': intance.user

    };
