import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final String? username;
  final String? password;

  const LoginModel({this.username, this.password});

  LoginModel copyWith({
    String? username,
    String? password,
  }) {
    return LoginModel(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'username': username, 'password': password};

  @override
  List<Object?> get props => [username, password];

  @override
  bool? get stringify => true;
}
