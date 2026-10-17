import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/ui_helpers.dart';
import '../auth/auth_actions.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  void edit(BuildContext c, String title, String init, void Function(String) ok) {
    final t = TextEditingController(text: init);
    showDialog(
      context: c,
      builder: (d) => AlertDialog(
        backgroundColor: cardC,
        shape: dlgShape,
        title: Text('แก้ไข $title'),
        content: TextField(controller: t, decoration: InputDecoration(labelText: title)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('ยกเลิก')),
          FilledButton(
            onPressed: () {
              ok(t.text.trim());
              S.i.ping();
              Navigator.pop(d);
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = S.i.me!;
    return ListView(padding: const EdgeInsets.symmetric(vertical: 12), children: [
      Center(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(shape: BoxShape.circle, color: gold, border: Border.all(color: ink, width: 2.5), boxShadow: const [BoxShadow(color: shd, offset: Offset(3, 3))]),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: u.photo ? acc : sand,
              child: Icon(Icons.person, size: 48, color: u.photo ? Colors.white : txt2),
            ),
          ),
          const SizedBox(height: 10),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Text(u.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
          const SizedBox(height: 4),
          pill('${u.pts} แต้มสะสม', goldDk),
        ]),
      ),
      const SizedBox(height: 16),
      card(Column(children: [
        ListTile(
          leading: const Icon(Icons.phone_outlined, color: acc2),
          title: const Text('เบอร์โทรศัพท์'),
          subtitle: Text(u.phone.isEmpty ? 'ยังไม่ระบุ' : u.phone),
          trailing: const Icon(Icons.edit, size: 18),
          onTap: () => edit(context, 'เบอร์โทรศัพท์', u.phone, (v) => u.phone = v),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.mail_outline, color: acc2),
          title: const Text('อีเมล'),
          subtitle: Text(u.email.isEmpty ? 'ยังไม่ระบุ' : u.email, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.edit, size: 18),
          onTap: () => edit(context, 'อีเมล', u.email, (v) => u.email = v),
        ),
      ])),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(foregroundColor: badC, side: const BorderSide(color: badC, width: 2)),
          onPressed: () => logout(context),
          icon: const Icon(Icons.logout),
          label: const Text('ออกจากระบบ'),
        ),
      ),
    ]);
  }
}
