part of 'user_model.dart';

User _$userModelFromJson(Map<String, dynamic> json) => User(
    id: json['id'] ?? 0 as int,
    name: json['name'] ?? '' as String,
    code: json['code'] ?? '' as String,
    phone: json['phone'] ?? '' as String,
    email: json['email'] ?? '' as String,
    avatar: json['avatar'] ?? '' as String,
    created_at: json['created_at'] ?? '' as String,
    updated_at: json['updated_at'] ?? '' as String,
    username: json['username'] ?? '' as String);

Map<String, dynamic> _$userModelToJson(User intance) => <String, dynamic>{
      'id': intance.id,
      'name': intance.name,
      'code': intance.code,
      'phone': intance.phone,
      'email': intance.email,
      'avatar': intance.avatar,
      'created_at': intance.created_at,
      'updated_at': intance.updated_at,
      'username': intance.username
    };
