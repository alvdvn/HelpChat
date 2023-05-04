import 'user_model.dart';
import 'package:equatable/equatable.dart';

class AuthModel extends Equatable {
  final AuthState state;
  final User? user;

  const AuthModel({required this.state, required this.user});

  const AuthModel.defaults()
      : state = AuthState.signup,
        user = null;

  @override
  List<Object?> get props => [state, user];

  @override
  bool? get stringify => true;

  AuthModel copyWith({AuthState? auth, User? user}) {
    return AuthModel(state: auth ?? state, user: user ?? this.user);
  }
}

enum AuthState { signup, login, authenticated }
