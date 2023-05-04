import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_view_model.dart';
import '../common/common_scaffold.dart';
import '../common/get_it.dart';
import '../inventory/inventory_widget.dart';
import '../messaging/messages_screen.dart';
import 'home_view_model.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (ctx, vm, ch) {
          return CommonScaffold(
            title: 'Pets',
            body: const InventoryWidget(),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute(builder: (_) {
                        return MessagesScreen(
                          title: 'Support',
                          channel:
                              getIt<AuthViewModel>().auth.user!.id.toString(),
                        );
                      }),
                    );
                  },
                  icon: const Icon(Icons.support_agent))
            ],
          );
        },
      ),
    );
  }
}
