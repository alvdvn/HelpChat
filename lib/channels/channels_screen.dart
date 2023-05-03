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
      title: 'Conflicts',
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
    );
  }
}
