import 'dart:io';

import 'package:flutter/material.dart';


import '../auth/auth_view_model.dart';
import '../common/extensions.dart';
import '../common/get_it.dart';
import 'message_response.dart';

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSender = message.from.id == getIt<AuthViewModel>().auth.user?.id;
    const radius = Radius.circular(10);
    final msgData = message;

    final hasText = !msgData.message.isNullOrBlank();

    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isSender ? Color(0xffcd323a) : Colors.grey[50],
            border: Border.all(
                color: isSender ? Colors.transparent : Colors.grey[300]!),
            borderRadius: BorderRadius.only(
              topLeft: radius,
              topRight: radius,
              bottomLeft: isSender ? radius : Radius.zero,
              bottomRight: isSender ? Radius.zero : radius,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasText)
                Text(
                  msgData.message!,
                  style: TextStyle(
                    color: isSender ? Colors.white : Colors.black,
                  ),
                ),

              const SizedBox(height: 5),
              // _getStatus(message, isSender, context),
            ],
          ),
        ),
      ),
    );
  }
}
