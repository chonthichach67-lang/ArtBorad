import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/models/app_user.dart';
import 'package:testtt/models/chat_message.dart';
import 'package:testtt/state/app_state.dart';

/// แชทระหว่างลูกค้ากับแอดมิน
class ChatPage extends StatelessWidget {
  final AppUser u;
  final bool admin;
  const ChatPage(this.u, this.admin, {super.key});
  @override
  Widget build(BuildContext context) {
    final t = TextEditingController();
    void send() {
      if (t.text.trim().isEmpty) return;
      AppState.i.chats.putIfAbsent(u, () => []).add(ChatMessage(admin, t.text.trim()));
      if (!admin) AppState.i.notes.add('💬 ${u.name}: ${t.text.trim()}');
      t.clear();
      AppState.i.ping();
    }

    return Scaffold(
        appBar: AppBar(title: Text(admin ? 'แชทกับ ${u.name}' : 'ติดต่อแอดมิน')),
        body: Column(children: [
          Expanded(
              child: AnimatedBuilder(
                  animation: AppState.i,
                  builder: (_, __) {
                    final l = AppState.i.chats[u] ?? [];
                    return ListView(padding: const EdgeInsets.all(12), children: [
                      for (final m in l)
                        Align(
                            alignment: m.admin == admin ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(margin: const EdgeInsets.symmetric(vertical: 4), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: m.admin == admin ? acc : Colors.white12, borderRadius: BorderRadius.circular(16)), child: Text(m.t, style: TextStyle(color: m.admin == admin ? Colors.black : Colors.white)))),
                    ]);
                  })),
          SafeArea(child: Padding(padding: const EdgeInsets.all(8), child: Row(children: [Expanded(child: TextField(controller: t, onSubmitted: (_) => send(), decoration: const InputDecoration(hintText: 'พิมพ์ข้อความ...', border: OutlineInputBorder()))), IconButton(onPressed: send, icon: const Icon(Icons.send, color: acc))]))),
        ]));
  }
}
