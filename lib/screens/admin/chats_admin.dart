import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/neon.dart';
import 'package:testtt/screens/chat/chat_page.dart';

class ChatsAdmin extends StatelessWidget {
  const ChatsAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    final users = AppState.i.users.where((x) => !x.admin).toList();
    if (users.isEmpty) return const Center(child: Text('ยังไม่มีลูกค้า'));
    return ListView(children: [
      for (final u in users)
        card(ListTile(
          leading: const Icon(Icons.account_circle, size: 36),
          title: Text(u.name),
          subtitle: Text('ข้อความล่าสุด: ${(AppState.i.chats[u] != null && AppState.i.chats[u]!.isNotEmpty) ? AppState.i.chats[u]!.last.t : "ไม่มีการสนทนา"}'),
          trailing: const Icon(Icons.chevron_right, color: acc),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(u, true))),
        ))
    ]);
  }
}
