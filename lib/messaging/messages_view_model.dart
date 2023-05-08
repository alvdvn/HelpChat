import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:uuid/uuid.dart';

import '../auth/auth_view_model.dart';
import '../common/get_it.dart';
import 'message_response.dart';
import 'messages_repository.dart';
import 'sendmessage_response.dart';

class MessagesViewModel extends ChangeNotifier {
  PusherChannelsFlutter? pusher;
  bool loading = true;
  final MessagesRepository repo;
  final String channel;
  final focusNode = FocusScopeNode();
  final textController = TextEditingController();
  final scrollController = ScrollController();

  MessagesViewModel(this.channel, this.repo) {
    setUpClient();
  }

  final _messages = <Message>[];

  List<Message> get messages => _messages;

  void setUpClient() async {
    pusher = await getIt.getAsync<PusherChannelsFlutter>();
    await pusher!.connect();
    pusher!.subscribe(channelName: 'chat.$channel', onEvent: onNewMessage);
    fetchPreviousMessages(channel);
  }

  void onNewMessage(dynamic event) {
    final data = json.decode(event.data.toString()) as Map<String, dynamic>;
    final message = Message.fromJson(data);
    if (message.from_id.length > 3) {
      _updateOrAddMessage(message);
    }
  }

  void fetchPreviousMessages(String room_id) async {
    final messages = await repo.fetchMessages(room_id);
    _messages.addAll(messages);
    loading = false;
    notifyListeners();
    _scrollToBottom();
  }

  void sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    //
    // final currentUser = getIt<AuthViewModel>().auth.user;
    final message = text;

    final success = await repo.sendMessage(message, channel);
    SendMessageResponse msg = await success;

    _updateOrAddMessage(msg.message);
  }

  void _updateOrAddMessage(Message message) {
    final index = _messages.indexOf(message);

    if (index >= 0) {
      _messages[index] = message;
    } else {
      _messages.add(message);
    }
    notifyListeners();
    _scrollToBottom();
    textController.text = '';
  }

  void _scrollToBottom() {
    if (_messages.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    pusher?.unsubscribe(channelName: channel);
    pusher?.disconnect();
    _messages.clear();
    super.dispose();
  }
}
