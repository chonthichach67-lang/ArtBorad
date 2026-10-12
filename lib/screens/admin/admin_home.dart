import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/logo.dart';
import 'package:testtt/screens/auth/login_page.dart';
import 'package:testtt/screens/admin/tables_admin.dart';
import 'package:testtt/screens/admin/queue_admin.dart';
import 'package:testtt/screens/admin/games_admin.dart';
import 'package:testtt/screens/admin/points_admin.dart';
import 'package:testtt/screens/admin/chats_admin.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [const TablesAdmin(), const QueueAdmin(), const GamesAdmin(), const PointsAdmin(), const ChatsAdmin()];
    return AnimatedBuilder(
        animation: AppState.i,
        builder: (_, __) {
          final n = AppState.i.notes.length;
          return Scaffold(
              appBar: AppBar(title: const Row(children: [Logo(30), SizedBox(width: 10), Text('ARTBOARD ADMIN', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2))]), actions: [
                IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications_outlined),
                        if (n > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(color: acc, shape: BoxShape.circle),
                              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                              child: Text('$n', style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            ),
                          )
                      ],
                    ),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (d) => AlertDialog(title: const Text('การแจ้งเตือน'), content: SizedBox(width: double.maxFinite, child: n == 0 ? const Text('ไม่มีการแจ้งเตือนใหม่') : ListView(shrinkWrap: true, children: [for (final x in AppState.i.notes.reversed) ListTile(dense: true, title: Text(x))])), actions: [
                              TextButton(onPressed: () { AppState.i.notes.clear(); AppState.i.ping(); Navigator.pop(d); }, child: const Text('ล้างทั้งหมด')),
                              TextButton(onPressed: () => Navigator.pop(d), child: const Text('ปิด'))
                            ]))),
                IconButton(icon: const Icon(Icons.logout), onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Login()), (r) => false)),
              ]),
              body: pages[i],
              bottomNavigationBar: NavigationBar(selectedIndex: i, onDestinationSelected: (v) => setState(() => i = v), destinations: const [
                NavigationDestination(icon: Icon(Icons.table_restaurant_outlined), label: 'โต๊ะ'),
                NavigationDestination(icon: Icon(Icons.list_alt), label: 'คิวจอง'),
                NavigationDestination(icon: Icon(Icons.casino_outlined), label: 'เกม'),
                NavigationDestination(icon: Icon(Icons.stars_outlined), label: 'แต้ม'),
                NavigationDestination(icon: Icon(Icons.chat_outlined), label: 'แชท'),
              ]));
        });
  }
}
