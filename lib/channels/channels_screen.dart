import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/common_scaffold.dart';
import '../common/get_it.dart';
import '../messaging/messages_screen.dart';
import 'channel_widget.dart';
import 'channels_view_model.dart';

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({Key? key}) : super(key: key);

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
