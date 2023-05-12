import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_view_model.dart';
import '../common/get_it.dart';
import 'channels_repository.dart';
import 'channel_response.dart';

class ChannelsViewModel extends ChangeNotifier {
  PusherChannelsFlutter? _pusher;
  bool loading = true;
  final ChannelsRepository _repo;
  final _channel = '';

  ChannelsViewModel(this._repo) {
    setUpClient();
    initPusherBeams();
    getSecure();
  }

  final _channels = <Channel>[];

  List<Channel> get channels => _channels;

  void setUpClient() async {
    _pusher = await getIt.getAsync<PusherChannelsFlutter>();
    await _pusher!.connect();
    _pusher!.subscribe(channelName: 'chat.$_channel', onEvent: onNewChannel);
    print(_channel);
    fetchChannelsHistory();
  }

  void onNewChannel(dynamic event) {
    final data = json.decode(event.data as String) as Map<String, dynamic>;
    final message = Channel.fromJson(data);
    _addOrUpdateChannel(message);
  }

  Future<bool> onSeen(String param) async {
   final bool result = await _repo.putSeen(param);
    return result;
  }

  void fetchChannelsHistory() async {
    _channels.clear();
    final channels = await _repo.fetchChannels();
    _channels.addAll(channels);

      _channels.sort((a,b)=>b.count_unseen.compareTo(a.count_unseen));
    loading = false;
    notifyListeners();
  }

  void _addOrUpdateChannel(Channel message) {
    _channels.removeWhere((e) => e.id == message.id);
    _channels.insert(0, message);
    notifyListeners();
  }
  @override
  void initState() {
    fetchChannelsHistory();
    // TODO: implement initState

  }

  void getSecure() async {
    final provider = BeamsAuthProvider()
      ..authUrl = 'https://dev.raihomes.vn/api/v1/counselor/pusher/beams-auth'
      ..headers = {
        'Content-Type': 'application/json',
        'Authorization':
        'Bearer ${getIt<SharedPreferences>().getString('_AUTH_TOKEN')}'
      }
      ..queryParams = {'page': '1'}
      ..credentials = 'omit';

    await PusherBeams.instance.setUserId(
        '${getIt<AuthViewModel>().auth.user?.username}-'
            '${getIt<AuthViewModel>().auth.user?.id}',
        provider,
            (error) => {
          if (error != null) {print(error)}
          // Success! Do something...
        });
  }

  void initPusherBeams() async {
    // Let's see our current interests
    print(await PusherBeams.instance.getDeviceInterests());

    // This is not intented to use in web
    if (!kIsWeb) {
      await PusherBeams.instance
          .onInterestChanges((interests) => {print('Interests: $interests')});

      await PusherBeams.instance
          .onMessageReceivedInTheForeground(_onMessageReceivedInTheForeground);
    }
    await _checkForInitialMessage();
  }

  Future<void> _checkForInitialMessage() async {
    final initialMessage = await PusherBeams.instance.getInitialMessage();
    if (initialMessage != null) {
      fetchChannelsHistory();
    }
  }

  void _onMessageReceivedInTheForeground(Map<Object?, Object?> data) {
    fetchChannelsHistory();
  }

  // void _showAlert(String title, String message) {
  //   var alert = AlertDialog(
  //       title: Text(title), content: Text(message), actions: const []);
  //

  // }
  @override
  void dispose() {
    _pusher?.unsubscribe(channelName: _channel);
    _pusher?.disconnect();
    _channels.clear();
    super.dispose();
  }
}
