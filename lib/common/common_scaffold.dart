import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;

  const CommonScaffold(
      {required this.title,
      required this.body,
      this.bottomNavigationBar,
      this.actions,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffcd323a),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(title),
        actions: actions,
      ),
      body: SizedBox.expand(child: body),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}


