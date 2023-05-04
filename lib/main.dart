
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'common/app_config.dart';
import 'auth/auth_widget.dart';
import 'common/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // const instanceID = '3b329529-fa88-40f7-bfc3-36599016df04';
  // await PusherBeams.instance.start(instanceID);
  // NativeNotify.initialize(2905, '4htdDbAx2i7MehXLdaiphB', null, null);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  const config = AppConfig(
      apiUrl: 'https://dev.raihomes.vn/api/v1/counselor/',
      pusherAPIKey: 'd0e0365ccbad9c0d9372',
      pusherCluster: 'ap1');
  initServices(config);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
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
