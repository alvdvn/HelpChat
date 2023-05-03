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

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../channels/channels_repository.dart';
import '../inventory/inventory_repository.dart';
import '../messaging/messages_repository.dart';
import 'app_config.dart';
import '../auth/auth_repository.dart';
import '../auth/auth_view_model.dart';
import 'extensions.dart';

GetIt getIt = GetIt.I;

void initServices(AppConfig config) {
  getIt.registerSingleton<AppConfig>(config);
  getIt.registerLazySingletonAsync(() => SharedPreferences.getInstance());
  getIt.registerLazySingleton(() => _getHttpClient(config.apiUrl));
  getIt.registerFactory(() => AuthRepository(getIt()));
  getIt.registerFactory(() => InventoryRepository(getIt()));
  getIt.registerFactory(() => MessagesRepository(getIt()));
  getIt.registerFactory(() => ChannelsRepository(getIt()));
  getIt.registerLazySingleton(() => AuthViewModel(getIt()));
  getIt.registerLazySingletonAsync(() => _getPusher(config));
}

Dio _getHttpClient(String url) {
  final logger = PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
  );
  final headers = <String, dynamic>{'Accept': 'application/json'};
  final options = BaseOptions(
    baseUrl: url,
    headers: headers,
    responseType: ResponseType.json,
  );
  final dio = Dio(options);
  dio.interceptors.add(logger);
  final refreshTokenInterceptor = InterceptorsWrapper(
      onRequest: (RequestOptions o, RequestInterceptorHandler h) async {
    if (o.path == AuthRepository.refreshTokenPath) {
      o.headers.remove('Authorization');
      return h.next(o);
    }
    final token = await getIt<AuthViewModel>().refreshToken();
    if (!token.isNullOrBlank()) o.headers['Authorization'] = 'Bearer $token';
    return h.next(o);
  }, onError: (DioError e, ErrorInterceptorHandler h) {
    if (e.response?.statusCode == HttpStatus.unauthorized) {
      getIt<AuthViewModel>().logOut();
    }
    return h.next(e);
  });
  dio.interceptors.add(refreshTokenInterceptor);
  return dio;
}

Future<PusherChannelsFlutter> _getPusher(AppConfig config) async {
  final pusher = PusherChannelsFlutter.getInstance();
  await pusher.init(apiKey: config.pusherAPIKey, cluster: config.pusherCluster);
  return pusher;
}
