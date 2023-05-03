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
