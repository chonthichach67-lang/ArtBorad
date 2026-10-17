import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import '../../state/app_state.dart';
import '../../widgets/ui_helpers.dart';

class ChatPage extends StatefulWidget {
  final U targetUser;
  final bool isAdmin;
  const ChatPage(this.targetUser, this.isAdmin, {super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final msgCtrl = TextEditingController();
  final scroll = ScrollController();

  @override
  void dispose() {
    msgCtrl.dispose();
    scroll.dispose();
    super.dispose();
  }

  void _send(List<M> list) {
    if (msgCtrl.text.trim().isEmpty) return;
    list.add(M(widget.isAdmin, msgCtrl.text.trim()));
    msgCtrl.clear();
    S.i.ping();
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) scroll.animateTo(scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = S.i.chats.putIfAbsent(widget.targetUser, () => []);
    final maxBubble = (MediaQuery.of(context).size.width * .78).clamp(0.0, 520.0).toDouble();
    return Scaffold(
      appBar: AppBar(title: Text('แชทกับ ${widget.isAdmin ? widget.targetUser.name : "แอดมิน"}', maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: Column(children: [
        Expanded(
          child: AnimatedBuilder(
            animation: S.i,
            builder: (_, __) => list.isEmpty
                ? emptyState(Icons.forum_outlined, 'ยังไม่มีข้อความ เริ่มสนทนาได้เลย')
                : ListView.builder(
                    controller: scroll,
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (_, idx) {
                      final m = list[idx];
                      final isMe = widget.isAdmin ? m.admin : !m.admin;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: maxBubble),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe ? gold : cardC,
                            border: Border.all(color: ink, width: 2),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 16),
                            ),
                            boxShadow: const [BoxShadow(color: shd, offset: Offset(2, 2))],
                          ),
                          child: Text(m.t, style: TextStyle(height: 1.3, fontWeight: FontWeight.w500, color: isMe ? dk : fg)),
                        ),
                      );
                    },
                  ),
          ),
        ),
        SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(color: cardC, border: Border(top: BorderSide(color: lineC, width: 2))),
            child: Row(children: [
              Expanded(child: TextField(controller: msgCtrl, onSubmitted: (_) => _send(list), decoration: const InputDecoration(hintText: 'พิมพ์ข้อความ...'))),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: acc, foregroundColor: Colors.white),
                icon: const Icon(Icons.send),
                onPressed: () => _send(list),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
