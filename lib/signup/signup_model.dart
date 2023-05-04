import 'package:equatable/equatable.dart';

class SignUpModel extends Equatable {
  final String? name;
  final String? email;
  final String? password;
  final bool isAdmin;

  const SignUpModel(
      {this.name, this.email, this.password, required this.isAdmin});

  SignUpModel copyWith({
    String? name,
    String? email,
    String? password,
    bool? isAdmin,
  }) {
    return SignUpModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name!,
        'email': email!,
        'password': password!,
        'isAdmin': isAdmin
      };

  @override
  List<Object?> get props => [name, email, password, isAdmin];

  @override
  bool? get stringify => true;
}
