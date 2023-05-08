import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/extensions.dart';
import '../common/get_it.dart';
import '../login/login_model.dart';
import 'user_model.dart';
import 'auth_model.dart';
import '../signup/signup_model.dart';
import 'auth_repository.dart';
import 'login_response.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repo;

  AuthViewModel(this.repo) {
    getIt.isReady<SharedPreferences>().then((_) {
      final pref = getIt<SharedPreferences>();
      if (pref.containsKey(_authUser) && pref.containsKey(_authToken)) {
        final token = pref.getString(_authToken)!;
        final user = User.fromStr(pref.getString(_authUser)!);

        _setAuthenticated(token, user);
      }
    });
  }

  var auth = const AuthModel.defaults();
  String? error;
  bool loading = false;

  void signUp(SignUpModel formData) async {
    loading = true;
    error = null;
    notifyListeners();
    final res = await repo.signup(formData);
    loading = false;

    if (res?.logindata != null) {
      _updateUserSession(res!);
      return;
    }
    error = 'Something went wrong';
    notifyListeners();
  }

  void login(LoginModel formData) async {
    loading = true;
    error = null;
    notifyListeners();
    final res = await repo.login(formData);
    print(res!.logindata);
    loading = false;

    if (res?.logindata != null) {
      _updateUserSession(res!);
      return;
    }
    error = 'Something went wrong';
    notifyListeners();
  }

  void showLogin() {
    auth = auth.copyWith(auth: AuthState.login);
    notifyListeners();
  }

  // void showSignUp() {
  //   auth = auth.copyWith(auth: AuthState.signup);
  //   notifyListeners();
  // }

  void _updateUserSession(LoginResponse res) {
    final token = res.logindata?.access_token;
    final pref = getIt<SharedPreferences>();

    if (token.isNullOrBlank()) {
      // _clearUserSession();
      return;
    }

    final user = User.fromLogin(res);

    pref.setString(_authUser, user.toJson());
    _persistTokens(token!);

    _setAuthenticated(token, user);
  }

  void _setAuthenticated(String token, User? user) {
    getIt<Dio>().options.headers['Authorization'] = 'Bearer $token';
    if (user != null) {
      auth = auth.copyWith(auth: AuthState.authenticated, user: user);
      notifyListeners();
    }
  }

  // Future<String?> refreshToken() async {
  //   final pref = getIt<SharedPreferences>();
  //   // final refreshToken = pref.getString(_authRefreshToken);
  //   // final expiresAt = pref.getInt(_authTokenExpiresAt);
  //
  //   // If we have an id token but can't refresh it
  //   // if (refreshToken.isNullOrBlank() || expiresAt == null) {
  //   //   return null;
  //   // }
  //   //
  //   // final now = DateTime.now().millisecondsSinceEpoch;
  //   // final refresh = (expiresAt - now) <= _minTokenLife;
  //   //
  //   // // If Id token has not expired or even close to expiration
  //   // if (!refresh) return null;
  //
  //   final res = await repo.refreshToken(refreshToken!);
  //   if (!res.isValid()) return null;
  //
  //   _setAuthenticated(res.data!.access_token, null);
  //   _persistTokens(
  //     res.data!.access_token,
  //
  //   );
  //   return res.data!.access_token;
  // }

  void logOut() {
    // _clearUserSession();
    loading = false;
    error = 'User session is expired';
    auth = auth.copyWith(auth: AuthState.login);
    notifyListeners();
  }

  void _persistTokens(String token) {
    final pref = getIt<SharedPreferences>();


    pref.setString(_authToken, token);

  }

  // void _clearUserSession() {
  //   final pref = getIt<SharedPreferences>();
  //   pref.remove(_authToken);
  //   pref.remove(_authUser);
  //   // pref.remove(_authRefreshToken);
  //   // pref.remove(_authTokenExpiresAt);
  // }
}

const String _authToken = '_AUTH_TOKEN';
// const String _authRefreshToken = '_AUTH_REFRESH_TOKEN';
// const String _authTokenExpiresAt = '_AUTH_TOKEN_EXPIRES_AT';
const String _authUser = '_AUTH_USER';
const int _minTokenLife = 10 * 60 * 1000; // 10 minutes