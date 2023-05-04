import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/common_scaffold.dart';
import '../common/get_it.dart';
import 'message_widget.dart';
import 'messages_view_model.dart';

class MessagesScreen extends StatelessWidget {
  final String title;
  final String channel;

  const MessagesScreen({required this.title, required this.channel, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return ChangeNotifierProvider<MessagesViewModel>(
      create: (_) => MessagesViewModel(channel, getIt()),
      child: Consumer<MessagesViewModel>(
        builder: (ctx, vm, _) {
          return CommonScaffold(
            title: title,
            body: GestureDetector(
              onTap: vm.focusNode.unfocus,
              child: _BodyWidget(vm: vm, bottom: bottom),
            ),
            bottomNavigationBar: _InputWidget(vm: vm, bottom: bottom),
          );
        },
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  final MessagesViewModel vm;
  final double bottom;

  const _BodyWidget({required this.vm, required this.bottom, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vm.loading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    final messages = vm.messages;
    if (messages.isEmpty) {
      return const Center(child: Text('You have not sent any messages yet'));
    }

    return ListView.builder(
      itemCount: messages.length,
      controller: vm.scrollController,
      padding: EdgeInsets.only(bottom: bottom),
      itemBuilder: (_, i) {
        final message = messages[i];
        return MessageWidget(
          message: message,
          key: ValueKey(message.room_id),
        );
      },
    );
  }
}

class _InputWidget extends StatelessWidget {
  final MessagesViewModel vm;
  final double bottom;

  const _InputWidget({required this.vm, required this.bottom, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Transform.translate(
      offset: Offset(0.0, -1 * bottom),
      child: SafeArea(
        bottom: bottom < 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              minLines: 1,
              maxLines: 3,
              focusNode: vm.focusNode,
              controller: vm.textController,
              autofocus: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).canvasColor,
                hintText: 'Enter a message',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                suffixIcon: IconButton(
                  onPressed: vm.sendMessage,
                  icon: const Icon(Icons.send),
                ),

                ),
              ),

          ],
        ),
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  final XFile file;
  final VoidCallback onRemove;
  final double size;

  const _ImageWidget({
    Key? key,
    required this.onRemove,
    required this.file,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageSize = size - 15;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 10),
      child: SizedBox(
        height: size,
        width: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(file.path),
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.cancel),
              ),
            )
          ],
        ),
      ),
    );
  }
}
