import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_view_model.dart';
import '../common/common_scaffold.dart';
import '../common/get_it.dart';
import '../messaging/messages_screen.dart';
import 'channel_widget.dart';
import 'channels_view_model.dart';

// class ChannelsScreen extends StatelessWidget {
//   const ChannelsScreen({Key? key}) : super(key: key);
class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({Key? key}) : super(key: key);

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPusherBeams();
    getSecure();
  }
  void getSecure() async {
    final BeamsAuthProvider provider = BeamsAuthProvider()
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
      _showAlert('Initial Message Is:', initialMessage.toString());
    }
  }

  void _onMessageReceivedInTheForeground(Map<Object?, Object?> data) {
    _showAlert(data['title'].toString(), data['body'].toString());
  }

  void _showAlert(String title, String message) {
    AlertDialog alert = AlertDialog(
        title: Text(title), content: Text(message), actions: const []);

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Chats',
      body: ChangeNotifierProvider(
        create: (_) => ChannelsViewModel(getIt()),
        child: Consumer<ChannelsViewModel>(
          builder: (ctx, vm, ch) {
            if (vm.loading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            final channels = vm.channels;
            if (channels.isEmpty) {
              return const Center(child: Text('No conflicts yet.'));
            }
            return ListView.separated(
              itemCount: channels.length,
              itemBuilder: (_, i) {
                final channel = channels[i];

                return ChannelWidget(
                  channel: channel,
                  key: ValueKey(channel.id),
                  onTap: () {
                    vm.onSeen('${channel.pivot.room_id}/seen');
                    Navigator.of(context).push<void>(
                      MaterialPageRoute(builder: (_) {
                        return MessagesScreen(
                          title: channel.name,
                          channel: channel.pivot.room_id.toString(),
                        );
                      }),
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xffcd323a),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                print('tapped');
              },
              icon: Image.asset('assets/images/live-chat.png',color: Colors.white,),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
