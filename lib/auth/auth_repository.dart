// Copyright (c) 2023 Razeware LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
// distribute, sublicense, create a derivative work, and/or sell copies of the
// Software in any work that is designed, intended, or marketed for pedagogical
// or instructional purposes related to programming, coding, application
// development, or information technology.  Permission for such use, copying,
// modification, merger, publication, distribution, sublicensing, creation of
// derivative works, or sale is expressly withheld.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
