import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../models/user.dart';
import '../../state/app_state.dart';
import '../../widgets/section_title.dart';
import '../../widgets/ui_helpers.dart';
import '../chat/chat_page.dart';

/// แท็บแชทลูกค้า (แอดมิน)
class AdminChatsTab extends StatelessWidget {
  final List<U> customers;
  const AdminChatsTab(this.customers, {super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        const Sec('แชทลูกค้า'),
        for (final u in customers)
          card(ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(backgroundColor: sand, child: Icon(Icons.person, color: acc2)),
            title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.w900)),
            subtitle: Text((S.i.chats[u]?.isNotEmpty ?? false) ? S.i.chats[u]!.last.t : 'ข้อความล่าสุด: ไม่มีการสนทนา',
                maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right, color: acc2, size: 28),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(u, true))),
          )),
      ]);
}
