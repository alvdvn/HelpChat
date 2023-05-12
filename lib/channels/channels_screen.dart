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

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({Key? key}) : super(key: key);

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen>
    with WidgetsBindingObserver {

  late bool rwidget = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
   Future<void> onRefresh() async{
       setState(() {
         getIt<ChannelsViewModel>().fetchChannelsHistory();
       });

   }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Chats',
      body: RefreshIndicator(
        onRefresh: onRefresh,
      child:  ChangeNotifierProvider(
        create: (_) => ChannelsViewModel(getIt()),
        child: Consumer<ChannelsViewModel>(
          builder: (ctx, vm, ch) {
            if (vm.loading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            rwidget =false;
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
                    Navigator.of(context).pushAndRemoveUntil<void>(
                        MaterialPageRoute(
                            builder: (context) => MessagesScreen(
                                  title: channel.name,
                                  channel: channel.pivot.room_id.toString(),
                                )),
                        ModalRoute.withName('/')).then((value) => {vm.fetchChannelsHistory()});
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          },
        ),
      )),
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
              icon: Image.asset(
                'assets/images/live-chat.png',
                color: Colors.white,
              ),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

}
