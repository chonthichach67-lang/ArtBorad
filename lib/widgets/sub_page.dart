import 'package:flutter/material.dart';
import 'package:testtt/state/app_state.dart';

/// หน้าย่อยที่รีเฟรชอัตโนมัติเมื่อ AppState เปลี่ยน
class SubPage extends StatelessWidget {
  final String title;
  final Widget body;
  const SubPage(this.title, this.body, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: AnimatedBuilder(animation: AppState.i, builder: (_, __) => body));
}
