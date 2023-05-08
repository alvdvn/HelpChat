import 'package:flutter/material.dart';

import '../common/extensions.dart';
import 'channel_response.dart';

class ChannelWidget extends StatelessWidget {
  final Channel channel;
  final VoidCallback onTap;


  const ChannelWidget(
      {required this.channel,
      required this.onTap,
      Key? key,
     })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: _avatarSize,
              height: _avatarSize,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black),
              child: const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/avt.jpeg'),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channel.name ?? '\u1f4f7',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.getFormattedTime(DateTime.parse(channel.create_at)),
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // Text(
                  //   context
                  //       .getFormattedTime(DateTime.parse(channel.create_at))
                  //       .substring(10, 15),
                  //   style: const TextStyle(
                  //     color: Colors.grey,
                  //     fontSize: 14,
                  //   ),
                  // ),
                ]),
          ],
        ),
      ),
    );
  }
}

const _avatarSize = 50.0;
