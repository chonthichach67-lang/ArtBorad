import 'package:flutter/material.dart';

import '../state/app_state.dart';

class SubPage extends StatelessWidget {
  final String title;
  final Widget body;
  const SubPage(this.title, this.body, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: AnimatedBuilder(animation: S.i, builder: (_, __) => body));
}
