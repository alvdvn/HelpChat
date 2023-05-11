
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/app_config.dart';
import 'auth/auth_widget.dart';
import 'common/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const config = AppConfig(
      apiUrl: 'https://dev.raihomes.vn/api/v1/counselor/',
      pusherAPIKey: 'd0e0365ccbad9c0d9372',
      pusherCluster: 'ap1');
  initServices(config);
  const instanceID = '3b329529-fa88-40f7-bfc3-36599016df04';
  await PusherBeams.instance.start(instanceID);
  PusherBeams.instance.clearAllState();
  // NativeNotify.initialize(2905, '4htdDbAx2i7MehXLdaiphB', null, null);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context){
    initializeDateFormatting();
    return MaterialApp(
      title: 'Chats',
      debugShowCheckedModeBanner: false,
      color: Colors.red,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWidget(),
    );
  }
}