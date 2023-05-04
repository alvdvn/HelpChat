import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/get_it.dart';
import 'inventory_view_model.dart';

class InventoryWidget extends StatelessWidget {
  const InventoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InventoryViewModel>(
      create: (_) => InventoryViewModel(getIt(), MediaQuery.of(context).size),
      child: Consumer<InventoryViewModel>(
        builder: (ctx, vm, ch) {
          return FutureBuilder(
            future: vm.covers,
            builder: (ctx, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snap.hasError) {
                return _ErrorWidget(snap.error.toString());
              }

              final covers = snap.data;

              if (!snap.hasData || covers!.isEmpty) {
                return const _ErrorWidget('No Pets');
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: covers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(covers[index], fit: BoxFit.cover);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;

  const _ErrorWidget(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(30),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.redAccent[400]),
      ),
    );
  }
}
