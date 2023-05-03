import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'login_response.dart';

part 'user_model.g.dart';

class User extends Equatable {
  int id;
  String name;
  String code;
  String phone;
  String email;
  String avatar;
  String created_at;

  // ignore: non_constant_identifier_names
  String updated_at;
  String username;

  User(
      {required this.id,
      required this.name,
      required this.code,
      required this.phone,
      required this.email,
      required this.avatar,
      required this.created_at,
      required this.updated_at,
      required this.username});

  factory User.fromLogin(LoginResponse res) {
    final data = res.logindata!.user;
    return User(
      id: data.id,
      name: data.name,
      code: data.code,
      phone: data.phone,
      email: data.email,
      avatar: data.avatar,
      created_at: data.created_at,
      updated_at: data.updated_at,
      username: data.username,
    );
  }

  factory User.fromStr(String str) {
    final j = json.decode(str) as Map<String, dynamic>;
    return User(
        id: j['id'] as int,
        name: j['name'] as String,
        code: j['code'] as String,
        phone: j['phone'] as String,
        email: j['email'] as String,
        avatar: j['avatar'] as String,
        created_at: j['create_at'] as String,
        updated_at: j['update_at'] as String,
        username: j['username'] as String);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$userModelFromJson(json);

  static String _generateAvatar(String fullName) {
    final split = fullName.split(' ');
    if (split.length < 2) return fullName[0];
    return '${split[0][0]}${split[1][0]}'.toUpperCase();
  }

  String toJson() => json.encode({
        'id': id,
        'name': name,
        'code': code,
        'phone': phone,
        'email': email,
        'avatar': avatar,
        'createe_at': created_at,
        'updatee_at': updated_at,
        'username': username
      });

  @override
  List<Object?> get props =>
      [id, name, code, phone, email, avatar, created_at, updated_at, username];

  @override
  bool? get stringify => true;
}
