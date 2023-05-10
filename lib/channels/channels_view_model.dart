import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

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
  }

  final _channels = <Channel>[];

  List<Channel> get channels => _channels;

  void setUpClient() async {
    _pusher = await getIt.getAsync<PusherChannelsFlutter>();
    await _pusher!.connect();
    _pusher!.subscribe(channelName: 'chat.$_channel', onEvent: onNewChannel);
    fetchChannelsHistory();
  }

  void onNewChannel(dynamic event) {
    final data = json.decode(event.data as String) as Map<String, dynamic>;
    final message = Channel.fromJson(data);
    _addOrUpdateChannel(message);
  }

  Future<bool> onSeen(String param) async {
    return _repo.putSeen(param);
  }

  void fetchChannelsHistory() async {
    final channels = await _repo.fetchChannels();
    _channels.addAll(channels);
    loading = false;
    notifyListeners();
  }

  void _addOrUpdateChannel(Channel message) {
    _channels.removeWhere((e) => e.id == message.id);
    _channels.insert(0, message);
    notifyListeners();
  }

  @override
  void dispose() {
    _pusher?.unsubscribe(channelName: _channel);
    _pusher?.disconnect();
    _channels.clear();
    super.dispose();
  }
}
