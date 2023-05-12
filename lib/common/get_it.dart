import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../channels/channels_repository.dart';
import '../channels/channels_view_model.dart';
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
  getIt.registerLazySingleton(() => ChannelsViewModel(getIt()));
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
    // final token = await getIt<AuthViewModel>().refreshToken();
    // if (!token.isNullOrBlank()) o.headers['Authorization'] = 'Bearer $token';
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
