import 'refresh_response.dart';
import 'package:dio/dio.dart';

import '../login/login_model.dart';
import '../signup/signup_model.dart';
import 'login_response.dart';

class AuthRepository {
  final Dio _dio;
  static const refreshTokenPath = '/refresh';

  AuthRepository(Dio dio) : _dio = dio;

  Future<LoginResponse?> login(LoginModel model) async {
    const path = '/login';
    try {
      final response = await _dio.post<Map>(path, data: model.toJson());
      final data = response.data;
      if (data == null) return null;

      return LoginResponse.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<LoginResponse?> signup(SignUpModel model) async {
    const path = '/signup';
    try {
      final response = await _dio.post<Map>(path, data: model.toJson());
      final data = response.data;
      if (data == null) return null;

      return LoginResponse.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<RefreshResponse> refreshToken(String refreshToken) async {
    final rData = {'refreshToken': refreshToken};
    try {
      final response = await _dio.post<Map>(refreshTokenPath, data: rData);
      final data = response.data;
      if (data == null) return RefreshResponse.empty();

      return RefreshResponse.fromJson(data);
    } catch (e) {
      return RefreshResponse.empty();
    }
  }
}
